//
//  EditEventView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 21/12/23.
//

import SwiftUI

struct AddEventView: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - ERROR
    @State private var errorMessage: String?
    
    //MARK: - ALERT
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    //MARK: - CLOCK INFO
    var clockEntry: ClockEntry
    @Binding var clockReport: ClockReport?
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    //MARK: - UPDATE INFO
    @State private var registeredTime: String = ""
    @State private var justification: String = ""
    @State private var dayOff: Bool = false
    @State private var doctor: Bool = false
    
    let onEventEdited: () -> Void
    
    //MARK: - INIT
    init(clockEntry: ClockEntry, clockReport: Binding<ClockReport?>, startDate: Binding<Date>, endDate: Binding<Date>, onEventEdited: @escaping () -> Void) {
        self.clockEntry = clockEntry
        self._clockReport = clockReport
        self._startDate = startDate
        self._endDate = endDate
        self.onEventEdited = onEventEdited
        
        _doctor = State(initialValue: false)
        _dayOff = State(initialValue: false)
        _justification = State(initialValue: "" )
        
        if let date = createFormatter("yyyy-MM-dd").date(from: clockEntry.day) {
            var _ = createFormatter("H:mm").string(from: date)
        }
        _registeredTime = State(initialValue: "12:00")
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
                Text("Adicionar registro")
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
                        .foregroundColor(ColorScheme.textColor)
                    Spacer()
                    Text("\(dayAndMonth)")
                        .foregroundColor(ColorScheme.tableTextColor)
                    TimeTextField(registeredTime: $registeredTime, time: "12:00")
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
                            .foregroundColor(ColorScheme.textColor)
                            .font(.system(size: 20))
                        Text("Ative se você está de atestado/laudo")
                            .foregroundColor(ColorScheme.tableTextColor)
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
                        .foregroundColor(.red)
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                }
                
                Button(action: {
                    if justification.isEmpty {
                        errorMessage = "ⓘ A justificativa é obrigatória"
                    } else if !isValidTime(registeredTime) {
                        errorMessage = "ⓘ Insira um horário válido"
                    } else {
                        errorMessage = ""
                        createAddTicket(clockEntry, justification, registeredTime)
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
                Alert(title: Text("Sucesso!"), message: Text("\(alertMessage)"), dismissButton: .default(Text("OK"), action: {
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
    
    func validateAndCorrectTime(time: String) -> String {
        let timeComponents = time.split(separator: ":")
        if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
            if hour > 23 || minute > 59 {
                return "23:59"
            }
        }
        return time
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

struct AddEventView_Previews: PreviewProvider {
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
            AddEventView(clockEntry: clockEntry, clockReport: $clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: {
                // DEBUG
            })
        }
    }
}

