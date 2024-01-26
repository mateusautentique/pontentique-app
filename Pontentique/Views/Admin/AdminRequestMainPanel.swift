//
//  AdminRequestMainPanel.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 17/01/24.
//

import SwiftUI

//MARK: REQUEST STRUCT
struct AdminRequest: Identifiable {
    var id = UUID()
    var name: String
    var details: String
    var time: String
    var reason: String
}

struct AdminRequestMainPanel: View {
//MARK: USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
//MARK: TICKETS
    @State private var tickets: [Ticket] = []
    
//MARK: ERROR
    @State private var errorMessage: String?
    
    var body: some View {
        
        VStack {
            Text("Solicitações")
                .font(.system(size: 28))
                .frame(maxWidth: .infinity, alignment: .center)
            
            List(tickets) { ticket in
                VStack(alignment: .leading) {
                    Text(ticket.userName).font(.headline)
                    Text(createDetailsString(ticket))
                        .font(.subheadline)
                        .foregroundColor(ticket.type == "delete" ? .red : .primary)
                    Text(ticket.justification).font(.caption)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        handleSelectedTicket(ticket, action: "approve")
                    } label: {
                        Text("Aceitar")
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        withAnimation {
                            handleSelectedTicket(ticket, action: "deny")
                        }
                    } label: {
                        Text("Negar")
                    }
                    .tint(.red)
                }
            }
            .onAppear(perform: getActiveTickets)
            .alert(isPresented: Binding<Bool>(
                get: { self.errorMessage != nil },
                set: { _ in self.errorMessage = nil }
            )) {
                Alert(title: Text("Erro"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
//MARK: TICKET FUNCTIONS
    private func handleSelectedTicket(_ ticket: Ticket, action: String) {
        if let index = tickets.firstIndex(where: { $0.id == ticket.id }) {
            if let user = sessionManager.user {
                handleTicket(ticket.id, action, user.token ?? "") { (message, error) in
                    if let message = message {
                        print(message)
                    }
                    if let error = error {
                        print(error.localizedDescription)
                        errorMessage = error.localizedDescription
                    }
                }
            }
            tickets.remove(at: index)
        }
    }
    
    private func getActiveTickets() {
        if let user = sessionManager.user {
            getAllActiveTickets(user.token ?? ""){ (result) in
                switch result {
                case .success(let fetchedTickets):
                    DispatchQueue.main.async {
                        self.tickets = fetchedTickets
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "ⓘ \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
//MARK: UTILS
    func createDetailsString(_ ticket: Ticket) -> String {
        var details = ""
        
        switch ticket.type {
        case "delete":
            details += "Exclusão"
        case "create":
            if let timestamp = ticket.requestedData?.timestamp {
                details += convertDateFormat(timestamp)
            }
        case "update":
            if let timestamp = ticket.requestedData?.timestamp {
                details += convertDateFormat(ticket.clockEventTimestamp ?? "")
                details += " → "
                details += convertDateFormat(timestamp)
            }
        default:
            return ""
        }
        
        if let doctor = ticket.requestedData?.doctor, doctor {
            details += " → Médico"
        } else if let dayOff = ticket.requestedData?.dayOff, dayOff {
            details += " → Folga"
        }
        
        return details
    }
    
    func convertDateFormat(_ dateString: String) -> String {
        let inputFormatter = createFormatter("yyyy-MM-dd HH:mm:ss")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = createFormatter("dd/MM HH:mm")
            return outputFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}

//MARK: PREVIEW
struct AdminRequestMainPanel_Previews: PreviewProvider {
    static var previews: some View {
        AdminRequestMainPanel()
            .environmentObject(UserSessionManager())
    }
}
