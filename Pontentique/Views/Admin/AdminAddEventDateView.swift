//
//  AdminEditEventDateView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 22/01/24.
//


import SwiftUI

struct AdminAddEventDateView: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - ERROR
    @State private var errorMessage: String?
    @State private var scrollToError: Bool = false
    //MARK: - ALERT
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    //MARK: - CLOCK INFO
    @Binding var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    let clockEntry: ClockEntry
    
    //MARK: - UPDATE INFO
    @State var startRegisteredTime: String
    @State var endRegisteredTime: String
    @State var startRegisteredDate: String
    @State var endRegisteredDate: String
    @State var justification: String = ""
    @State var dayOff: Bool = false
    @State var doctor: Bool = false
    
    let onEventEdited: () -> Void
    
    //MARK: - INIT
    init(clockEntry: ClockEntry, clockReport: Binding<ClockReport>, startDate: Binding<Date>, endDate: Binding<Date>, onEventEdited: @escaping () -> Void) {
        self.clockEntry = clockEntry
        self._clockReport = clockReport
        self._startDate = startDate
        self._endDate = endDate
        self.onEventEdited = onEventEdited
        
        _doctor = State(initialValue: false)
        _dayOff = State(initialValue: true)
        _justification = State(initialValue: "" )
        
        var dateString = ""
        if let date = createFormatter("yyyy-MM-dd").date(from: clockEntry.day) {
            dateString = createFormatter("dd/MM").string(from: date)
        }
        
        _startRegisteredTime = State(initialValue: "12:00")
        _endRegisteredTime = State(initialValue: "18:00")
        _startRegisteredDate = State(initialValue: dateString)
        _endRegisteredDate = State(initialValue: dateString)
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: - DATE FORMATTING
    var dayAndMonth: String {
        guard let date = createFormatter("yyyy-MM-dd").date(from: clockEntry.day) else {
            return "08/01"
        }
        return createFormatter("dd/MM").string(from: date)
    }
    
    //MARK: - VIEW
    var body: some View {
        VStack {
            HStack{
                Text("Registrar folga")
                Spacer()
            }
            .padding()
            .padding(.top, 5)
            .background(ColorScheme.fieldBgColor)
            .font(.system(size: 25))
            .padding(.bottom, 10)
            ScrollView{
                ScrollViewReader { scrollView in
                    VStack {
                        VStack {
                            HStack{
                                Text("Data de início")
                                    .foregroundStyle(ColorScheme.textColor)
                                    .font(.system(size: 20))
                                Spacer()
                                DateTextField(registeredDate: $startRegisteredDate, dayAndMonth: dayAndMonth)
                                TimeTextField(registeredTime: $startRegisteredTime, time: "10:00")
                            }
                            
                            HStack{
                                Text("Data de término")
                                    .foregroundStyle(ColorScheme.textColor)
                                    .font(.system(size: 20))
                                Spacer()
                                DateTextField(registeredDate: $endRegisteredDate, dayAndMonth: dayAndMonth)
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
                            .foregroundStyle(ColorScheme.textColor)
                            .cornerRadius(5)
                            .padding(.bottom, 10)
                            .lineLimit(5...10)
                        
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
                                    .foregroundStyle(ColorScheme.textColor)
                                    .font(.system(size: 20))
                                Text("Ative se você está de atestado/laudo")
                                    .foregroundStyle(ColorScheme.tableTextColor)
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
                                .foregroundStyle(.red)
                                .padding(.top, 10)
                                .padding(.bottom, 15)
                                .id("ErrorMessage")
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
        .gesture(
            TapGesture()
                .onEnded { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            errorMessage = nil
                        }
                    } else if !isValidTime(startRegisteredTime) ||
                                !isValidTime(endRegisteredTime) ||
                                endRegisteredTime < startRegisteredTime {
                        errorMessage = "ⓘ Insira um horário válido"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            errorMessage = nil
                        }
                    } else {
                        errorMessage = ""
                        setDayOff(clockEntry, clockReport, justification, startRegisteredDate, startRegisteredTime,
                                  endRegisteredDate, endRegisteredTime, dayOff, doctor)
                    }
                }){
                    Text("Salvar")
                }
            }
        }
    }
    
    //MARK: - AUX FUNCTIONS
    func setDayOff(_ entry: ClockEntry, _ report: ClockReport, _ justification: String,
                   _ startDate: String, _ startTime: String,
                   _ endDate: String, _ endTime: String, _ dayOff: Bool, _ doctor: Bool){
        if let user = sessionManager.user {
            let startDateConverted = formatDate(startDate, entry.day)
            var endDateConverted = formatDate(endDate, entry.day)
            let startTimeString = formatTime(startTime)
            let endTimeString = formatTime(endTime)

            if let start = startDateConverted, let end = endDateConverted {
                if end < start {
                    endDateConverted = Calendar.current.date(byAdding: .year, value: 1, to: end)
                }
            }

            let startDateString = convertDateToString(startDateConverted)
            let endDateString = convertDateToString(endDateConverted)

            setDayOffForDate(report.userId, justification, startDateString, startTimeString,
                             endDateString, endTimeString, dayOff, doctor, user.token ?? "")
            { (message, error) in
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if let message = message {
                    alertMessage = message
                    showingAlert = true
                }
            }
        }
    }

    func formatDate(_ date: String, _ eventDay: String) -> Date? {
        let year = String(eventDay.prefix(4))
        let dateWithYear = date + "/" + year

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy"

        return dateFormatterGet.date(from: dateWithYear)
    }

    func convertDateToString(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        return dateFormatterPrint.string(from: date)
    }
    func formatTime(_ time: String) -> String {
        if time.count == 4 { return "0" + time
        } else { return time }
    }
    
    func fetchUpdatedClockReport(_ startDate: String, _ endDate: String, _ report: ClockReport) {
        if let user = sessionManager.user {
            getClockEntriesByPeriod(report.userId, user.token ?? "", startDate: startDate, endDate: endDate) { (clockReport, error) in
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
    
    func isValidTime(_ time: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = time.count == 4 ? "H:mm" : "HH:mm"
        if formatter.date(from: time) == nil {
            return false
        }
        
        let components = time.split(separator: ":")
        return components[1].count == 2
    }
}
//MARK: - PREVIEW

struct AdminAddEventDateView_Previews: PreviewProvider {
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
            AdminAddEventDateView(clockEntry: clockEntry, clockReport: $clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: {
                // DEBUG
            })
        }
    }
}

