//
//  EditDateLinkView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 22/01/24.
//

import SwiftUI

struct UserAddEventDateView: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - ERROR
    @State private var errorMessage: String?
    
    //MARK: - ALERT
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    //MARK: - CLOCK INFO
    @Binding var clockReport: ClockReport?
    @Binding var startDate: Date
    @Binding var endDate: Date
    let clockEntry: ClockEntry
    
    //MARK: - UPDATE INFO
    @State var startRegisteredTime: String
    @State var endRegisteredTime: String
    @State var justification: String = ""
    @State var dayOff: Bool = false
    @State var doctor: Bool = false
    
    let onEventEdited: () -> Void
    
    //MARK: - INIT
    init(clockEntry: ClockEntry, clockReport: Binding<ClockReport?>, startDate: Binding<Date>, endDate: Binding<Date>, onEventEdited: @escaping () -> Void) {
        self.clockEntry = clockEntry
        self._clockReport = clockReport
        self._startDate = startDate
        self._endDate = endDate
        self.onEventEdited = onEventEdited
        
        _doctor = State(initialValue: false)
        _dayOff = State(initialValue: true)
        _justification = State(initialValue: "" )

        if let date = createFormatter("yyyy-MM-dd").date(from: clockEntry.day) {
            var _ = createFormatter("H:mm").string(from: date)
        }
        _startRegisteredTime = State(initialValue: "12:00")
        _endRegisteredTime = State(initialValue: "18:00")
    }
    

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: - DATE FORMATTING
    var dayAndMonth: String {
        guard let date = createFormatter("yyyy-MM-dd").date(from: clockEntry.day) else {
            return "12/01"
        }
        return createFormatter("d/MM").string(from: date)
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
                VStack {
                    HStack{
                        Text("Data de início")
                            .foregroundColor(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Spacer()
                        Text("\(dayAndMonth)")
                            .foregroundColor(ColorScheme.tableTextColor)
                        TimeTextField(registeredTime: $startRegisteredTime, time: "12:00")
                    }
                    
                    HStack{
                        Text("Data de término")
                            .foregroundColor(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Spacer()
                        Text("\(dayAndMonth)")
                            .foregroundColor(ColorScheme.tableTextColor)
                        TimeTextField(registeredTime: $endRegisteredTime, time: "18:00")
                    }
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
                    .foregroundColor(ColorScheme.textColor)
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                    .lineLimit(5...10)
                
                HStack{
                    VStack (alignment: .leading) {
                        Text("Folga")
                            .foregroundColor(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Text("Ative se você tirou folga neste horário")
                            .foregroundColor(ColorScheme.tableTextColor)
                    }
                    Spacer()
                    Toggle("", isOn: $dayOff)
                        .onChange(of: dayOff) {
                            if dayOff {doctor = false}
                            else {doctor = true}
                        }
                        .padding()
                }
                Divider()
                
                HStack{
                    VStack (alignment: .leading) {
                        Text("Médico")
                            .foregroundColor(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Text("Ative se você está de atestado/laudo")
                            .foregroundColor(ColorScheme.tableTextColor)
                    }
                    Spacer()
                    Toggle("", isOn: $doctor)
                        .onChange(of: doctor) {
                            if doctor {dayOff = false}
                            else {dayOff = true}
                        }
                        .padding()
                }
                Divider()
                
                Spacer()
                
                if let errorMessage = errorMessage {
                    Text("\(errorMessage)")
                        .foregroundColor(.red)
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                }
                
                Button(action: {
                    if justification.isEmpty {
                        errorMessage = "ⓘ A justificativa é obrigatória"
                    } else if !isValidTime(startRegisteredTime) || !isValidTime(endRegisteredTime) {
                        errorMessage = "ⓘ Insira um horário válido"
                    } else {
                        errorMessage = ""
                        createAddTicket(clockEntry, justification, startRegisteredTime)
                        createAddTicket(clockEntry, justification, endRegisteredTime)
                    }
                }){
                    Text("Salvar")
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(ColorScheme.fieldBgColor)
                        .foregroundColor(ColorScheme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 25)
                        .font(.system(size: 20))
                    
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Ponto editado com sucesso!"), message: Text("\(alertMessage)"), dismissButton: .default(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.onEventEdited()
                }))
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
        }
    }
    
    //MARK: - AUX FUNCTIONS
    
    func createAddTicket(_ event: ClockEntry, _ justification: String, _ timestamp: String) {
        let justification = justification
        let timestamp = replaceTimeInTimestamp(event.day, timestamp)
        
        if let user = sessionManager.user {
            let requestedData = RequestedData(userId: user.id, timestamp: timestamp, justification: justification,
                                              dayOff: dayOff, doctor: doctor)
            let ticketRequest = TicketRequest(userId: user.id, type: "create", clockEventId: nil,
                                              justification: justification, requestedData: requestedData)
            
            createTicket(ticketRequest, user.token ?? ""){ (message, error) in
                if let message = message {
                    DispatchQueue.main.async {
                        alertMessage = message
                        showingAlert = true
                    }
                } else if let error = error {
                    errorMessage = "ⓘ \(error.localizedDescription)"
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
    
    func replaceTimeInTimestamp(_ date: String, _ time: String) -> String {
        return "\(date) \(time):00"
    }
    
    func fetchUpdatedClockReport(_ startDate: String, _ endDate: String) {
        if let user = sessionManager.user {
            getClockEntriesByPeriod(user.id, user.token ?? "", startDate: startDate, endDate: endDate) { (clockReport, error) in
                if let clockReport = clockReport {
                    DispatchQueue.main.async {
                        self.clockReport = clockReport
                    }
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
}

//MARK: - PREVIEW

struct UserAddEventDateView_Previews: PreviewProvider {
    static var previews: some View {
        @State var clockReport: ClockReport? = ClockReport()
        @State var endDate = Date()
        @State var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let clockEntry = ClockEntry(day: "", normalHoursWorkedOnDay: "", extraHoursWorkedOnDay: "", balanceHoursOnDay: "", totalTimeWorkedInSeconds: 0, eventCount: 0, events: [])
        
        do {
            let url = Bundle.main.url(forResource: "EventExampleData", withExtension: "json")!
            _ = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(createFormatter("yyyy-MM-dd HH:mm:ss"))
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return NavigationView {
            UserAddEventDateView(clockEntry: clockEntry, clockReport: $clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: {
                // DEBUG
            })
        }
    }
}

