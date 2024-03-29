//
//  EditEventView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 21/12/23.
//

import SwiftUI
import UIKit
struct AddEventView: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - ERROR
    @State private var errorMessage: String?
    @State private var scrollToError: Bool = false
    //MARK: - ALERT
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    //MARK: - CLOCK INFO
    var clockEntry: ClockEntry
    @Binding var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    //MARK: - UPDATE INFO
    @State private var registeredTime: String = ""
    @State private var justification: String = ""
    @State private var dayOff: Bool = false
    @State private var doctor: Bool = false
    
    let onEventEdited: () -> Void
    
    //MARK: - INIT
    init(clockEntry: ClockEntry, clockReport: Binding<ClockReport>, startDate: Binding<Date>, endDate: Binding<Date>, onEventEdited: @escaping () -> Void) {
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
        _registeredTime = State(initialValue: "")
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
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack {
                        HStack{
                            Text("Horário registrado")
                                .foregroundStyle(ColorScheme.textColor)
                            Spacer()
                            Text("\(dayAndMonth)")
                                .foregroundStyle(ColorScheme.tableTextColor)
                            TimeTextField(registeredTime: $registeredTime, time: "12:00")
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
                                .id("ErrorMessage")
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.errorMessage = nil
                                    }
                                }
                        }
                    }
                    .onChange(of: errorMessage) {oldValue, newValue in
                        if errorMessage != nil {
                            withAnimation {
                                scrollToError = true
                            }
                        }
                    }
                    .onChange(of: scrollToError) {oldValue, newValue in
                        if scrollToError {
                            scrollView.scrollTo("ErrorMessage", anchor: .bottom)
                            scrollToError = false
                        }
                    }

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
                            addEvent(clockEntry, justification, registeredTime) :
                            createAddTicket(clockEntry, justification, registeredTime)
                        }
                    }
                }){
                    Text("Salvar")
                }
            }
        }
    }
    
    //MARK: - AUX FUNCTIONS
    
    func addEvent(_ entry: ClockEntry, _ justification: String, _ timestamp: String) {
        let timestamp = replaceTimeInTimestamp(entry.day, timestamp)
        
        if let user = sessionManager.user {
            addClockEvent(clockReport.userId, timestamp, justification, user.token ?? "", dayOff, doctor) { (message, error) in
                if let message = message {
                    DispatchQueue.main.async {
                        alertMessage = message
                        showingAlert = true
                    }
                } else if let error = error {
                    print("Error: \(error)")
                    errorMessage = "ⓘ \(error.localizedDescription)"
                }
            }
        }
    }
    
    func createAddTicket(_ entry: ClockEntry, _ justification: String, _ timestamp: String) {
        let timestamp = replaceTimeInTimestamp(entry.day, timestamp)
        
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
    
    func replaceTimeInTimestamp(_ date: String, _ time: String) -> String {
        return "\(date) \(time):00"
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
    
    func fetchUpdatedClockReport(_ startDate: String, _ endDate: String) {
        if let user = sessionManager.user {
            getClockEntriesByPeriod(clockReport.userId, user.token ?? "", startDate: startDate, endDate: endDate) { (clockReport, error) in
                if let clockReport = clockReport {
                    DispatchQueue.main.async {
                        self.clockReport = clockReport
                    }
                } else if let error = error {
                    errorMessage = "ⓘ \(error.localizedDescription)"
                }
            }
        }
    }
}


//MARK: - PREVIEW

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        @State var clockReport: ClockReport = ClockReport()
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

