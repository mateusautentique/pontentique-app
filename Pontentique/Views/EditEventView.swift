//
//  EditEventView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 21/12/23.
//
import UIKit
import SwiftUI

struct EditEventView: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - ERROR
    @State private var errorMessage: String?
    
    //MARK: - ALERT
    enum ActiveAlert { case edit, delete, doneDelete }
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .edit
    @State private var editAlertMessage = ""
    @State private var deleteAlertMessage = ""
    
    //MARK: - CLOCK INFO
    @Binding var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    let event: ClockEvent
    
    //MARK: - UPDATE INFO
    @State var registeredTime: String
    @State var justification: String = ""
    @State var dayOff: Bool = false
    @State var doctor: Bool = false
    
    let onEventEdited: () -> Void
    
    //MARK: - INIT
    init(event: ClockEvent, clockReport: Binding<ClockReport>, startDate: Binding<Date>, endDate: Binding<Date>, onEventEdited: @escaping () -> Void) {
        self.event = event
        self._clockReport = clockReport
        self._startDate = startDate
        self._endDate = endDate
        self.onEventEdited = onEventEdited
        
        _doctor = State(initialValue: event.doctor)
        _dayOff = State(initialValue: event.dayOff)
        _justification = State(initialValue: event.justification )
        
        var timeString = ""
        if let date = createFormatter("yyyy-MM-dd HH:mm:ss").date(from: event.timestamp) {
            timeString = createFormatter("H:mm").string(from: date)
        }
        _registeredTime = State(initialValue: timeString)
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: - DATE FORMATTING
    var dayAndMonth: String {
        guard let date = createFormatter("yyyy-MM-dd HH:mm:ss").date(from: event.timestamp) else {
            return ""
        }
        return createFormatter("d/MM").string(from: date)
    }
    
    var time: String {
        guard let date = createFormatter("yyyy-MM-dd HH:mm:ss").date(from: event.timestamp) else {
            return ""
        }
        return createFormatter("H:mm").string(from: date)
    }
    
    //MARK: - VIEW
    var body: some View {
        VStack {
            HStack{
                Text("Editar registro")
                Spacer()
            }
            .padding()
            .padding(.top, 5)
            .background(ColorScheme.fieldBgColor)
            .font(.system(size: 25))
            .padding(.bottom, 10)
            
            VStack {
                HStack{
                    Text("Horário registrado")
                        .foregroundStyle(ColorScheme.textColor)
                    Spacer()
                    Text("\(dayAndMonth)")
                        .foregroundStyle(ColorScheme.tableTextColor)
                    TimeTextField(registeredTime: $registeredTime, time: time)
                        .gesture(
                               TapGesture()
                                   .onEnded { _ in
                                       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   }
                           )
                }
                .background(ColorScheme.appBackgroudColor)
                .padding(.bottom, 15)
                .font(.system(size: 18))
                
                HStack {
                    Text("Motivo da alteração")
                        .font(.system(size: 20))
                    Spacer()
                }
                
                TextField("Motivo", text: $justification, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(ColorScheme.fieldBgColor)
                    .foregroundStyle(ColorScheme.textColor)
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                    .lineLimit(5...10)
                    .onChange(of: justification) { oldValue, newValue in
                        if newValue.count > 200 {
                            justification = String(newValue.prefix(200))
                        }
                    }
                    .gesture(
                           TapGesture()
                               .onEnded { _ in
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                               }
                       )
                
                
                HStack{
                    VStack (alignment: .leading) {
                        Text("Folga")
                            .foregroundStyle(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Text("Ative se você tirou folga neste horário")
                            .foregroundStyle(ColorScheme.tableTextColor)
                    }
                    Spacer()
                    Toggle("", isOn: $dayOff)
                        .onChange(of: dayOff) { oldValue, newValue in
                            if newValue {
                                doctor = false
                            }
                        }
                        .padding()
                }
                Divider()
                
                HStack{
                    VStack (alignment: .leading) {
                        Text("Médico")
                            .foregroundStyle(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Text("Ative se você está de atestado/laudo")
                            .foregroundStyle(ColorScheme.tableTextColor)
                    }
                    Spacer()
                    Toggle("", isOn: $doctor)
                        .onChange(of: doctor) { oldValue, newValue in
                            if newValue {
                                dayOff = false
                            }
                        }
                        .padding()
                }
                Divider()
                
                Spacer()
                
                if let errorMessage = errorMessage {
                    Text("\(errorMessage)")
                        .foregroundStyle(.red)
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                }
                
                Button(action: {
                    if justification.isEmpty {
                        errorMessage = "ⓘ A justificativa é obrigatória"
                    } else {
                        errorMessage = ""
                        self.activeAlert = .delete
                        self.showAlert = true
                    }
                }) {
                    Text("Excluir registro")
                        .foregroundStyle(.red)
                }
            }
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .edit:
                    return Alert(title: Text("Sucesso!"),
                                 message: Text("\(editAlertMessage)"),
                                 dismissButton: .default(Text("OK"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                        self.onEventEdited()
                    }))
                case .delete:
                    return Alert(title: Text("Confirmar exclusão"),
                                 message: Text("Tem certeza que deseja deletar esse registro?"),
                                 primaryButton: .destructive(Text("Excluir")) {
                            errorMessage = ""
                            if let user = sessionManager.user {
                                user.role == "admin" ?
                                deleteEvent(event) :
                                createDeleteTicket(event, justification, registeredTime)
                            }
                            self.activeAlert = .doneDelete
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.showAlert = true
                            }
                    }, secondaryButton: .cancel())
                case .doneDelete:
                    return Alert(title: Text("Sucesso!"),
                                 message: Text("\(deleteAlertMessage)"),
                                 dismissButton: .default(Text("OK"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                        self.onEventEdited()
                    }))
                }
            }
            .padding()
            .padding(.leading, 5)
            .padding(.trailing, 5)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.backward")
                        Text("Registros de ponto")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if justification.isEmpty {
                        errorMessage = "ⓘ A justificativa é obrigatória"
                    } else if !isValidTime(registeredTime) {
                        errorMessage = "ⓘ Insira um horário válido"
                    } else {
                        errorMessage = ""
                        if let user = sessionManager.user {
                            user.role == "admin" ?
                            editEvent(event, justification, registeredTime) :
                            createEditTicket(event, justification, registeredTime)
                        }
                    }
                }){
                    Text("Salvar")
                }
            }
        }
    }
    
    //MARK: - AUX FUNCTIONS
    
    func editEvent(_ event: ClockEvent, _ justification: String, _ timestamp: String) {
        let eventId = event.id
        let timestamp = replaceTimeInTimestamp(originalTimestamp: event.timestamp, newTime: timestamp)
        
        if let user = sessionManager.user {
            editClockEvent(eventId, timestamp, justification, user.token ?? "", dayOff, doctor) { (message, error) in
                if let message = message {
                    DispatchQueue.main.async {
                        self.editAlertMessage = message
                        self.showAlert = true
                        self.activeAlert = .edit
                    }
                } else if let error = error {
                    errorMessage = "ⓘ \(error.localizedDescription)"
                }
            }
        }
    }
    
    func createEditTicket(_ event: ClockEvent, _ justification: String, _ timestamp: String) {
        let eventId = event.id
        let timestamp = replaceTimeInTimestamp(originalTimestamp: event.timestamp, newTime: timestamp)
        
        if let user = sessionManager.user {
            let requestedData = RequestedData(userId: user.id, timestamp: timestamp,
                                              justification: justification, dayOff: dayOff, doctor: doctor)
            let ticketRequest = TicketRequest(userId: user.id, type: "update", clockEventId: eventId,
                                              justification: justification, requestedData: requestedData)
            
            createTicket(ticketRequest, user.token ?? ""){ (message, error) in
                if let message = message {
                    DispatchQueue.main.async {
                        self.editAlertMessage = message
                        self.showAlert = true
                        self.activeAlert = .edit
                    }
                } else if let error = error {
                    errorMessage = "ⓘ \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deleteEvent(_ event: ClockEvent) {
        if let user = sessionManager.user {
            deleteClockEvent(event.id, user.token ?? "") { (message, error) in
                if let message = message {
                    DispatchQueue.main.async {
                        self.deleteAlertMessage = message
                        self.activeAlert = .doneDelete
                        self.showAlert = true
                    }
                }
                if let error = error {
                    errorMessage = "ⓘ \(error.localizedDescription)"
                }
            }
        }
    }
    
    func createDeleteTicket(_ event: ClockEvent, _ justification: String, _ timestamp: String) {
        let eventId = event.id
        
        if let user = sessionManager.user {
            let ticketRequest = TicketRequest(userId: user.id,
                                              type: "delete",
                                              clockEventId: eventId,
                                              justification: justification,
                                              requestedData: nil)
            
            createTicket(ticketRequest, user.token ?? ""){ (message, error) in
                if let message = message {
                    DispatchQueue.main.async {
                        self.editAlertMessage = message
                        self.showAlert = true
                        self.activeAlert = .edit
                    }
                } else if let error = error {
                    self.errorMessage = "ⓘ \(error.localizedDescription)"
                }
            }
        }
    }
    
    func isValidTime(_ time: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = time.count == 4 ? "H:mm" : "HH:mm"
        if formatter.date(from: time) == nil {
            return false
        }
        
        let components = time.split(separator: ":")
        return components[1].count == 2
    }
    
    func replaceTimeInTimestamp(originalTimestamp: String, newTime: String) -> String {
        let timeIndex = originalTimestamp.index(originalTimestamp.startIndex, offsetBy: 11)
        let datePart = originalTimestamp[..<timeIndex]
        let formattedTime = newTime.count == 4 ? "0\(newTime)" : newTime
        return "\(datePart)\(formattedTime):00"
    }
    
    func fetchUpdatedClockReport(_ startDate: String, _ endDate: String) {
        if let user = sessionManager.user {
            getClockEntriesByPeriod(clockReport.userId, user.token ?? "", startDate: startDate, endDate: endDate) { (clockReport, error) in
                if let clockReport = clockReport {
                    DispatchQueue.main.async {
                        self.clockReport = clockReport
                    }
                } else if let error = error {
                    self.errorMessage = "ⓘ \(error.localizedDescription)"
                }
            }
        }
    }
}

//MARK: - PREVIEW

struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleEvent: ClockEvent
        @State var clockReport = ClockReport() // Initialize clockReport here
        @State var endDate = Date()
        @State var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        do {
            let url = Bundle.main.url(forResource: "EventExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(createFormatter("yyyy-MM-dd HH:mm:ss"))
            exampleEvent = try decoder.decode(ClockEvent.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            exampleEvent = ClockEvent(id: 0, timestamp: "", type: "", _justification: nil, doctor: false, dayOff: false)
        }
        
        return NavigationView {
            EditEventView(event: exampleEvent, clockReport: $clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: {
                // DEBUG
            })
        }
    }
}

//MARK: - AUX
extension String {
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        var counter = 0
        for character in self {
            if counter != 0 && counter % n == 0 {
                result.append(separator)
            }
            result.append(character)
            counter += 1
        }
        return result
    }
}

extension String {
    func inserting(separator: String, at i: Int) -> String {
        var str = self
        let index = str.index(str.startIndex, offsetBy: i)
        str.insert(contentsOf: separator, at: index)
        return str
    }
}
