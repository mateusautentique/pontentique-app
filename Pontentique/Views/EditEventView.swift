//
//  EditEventView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 21/12/23.
//

import SwiftUI

struct EditEventView: View {
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
    let event: ClockEvent
    
    //MARK: - UPDATE INFO
    @State var registeredTime: String
    @State var justification: String = ""
    @State var dayOff: Bool = false
    @State var doctor: Bool = false
    
    init(event: ClockEvent, clockReport: Binding<ClockReport?>, startDate: Binding<Date>, endDate: Binding<Date>) {
        self.event = event
        self._clockReport = clockReport
        self._startDate = startDate
        self._endDate = endDate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var timeString = ""
        if let date = dateFormatter.date(from: event.timestamp) {
            dateFormatter.dateFormat = "H:mm"
            timeString = dateFormatter.string(from: date)
        }
        _registeredTime = State(initialValue: timeString)
    }

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //MARK: - DATE FORMATTING
    let functionFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var dayAndMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: event.timestamp) {
            dateFormatter.dateFormat = "d/MM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: event.timestamp) {
            dateFormatter.dateFormat = "H:mm"
            return dateFormatter.string(from: date)
        }
        return ""
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
                        .foregroundColor(ColorScheme.textColor)
                    Spacer()
                    Text("\(dayAndMonth)")
                        .foregroundColor(ColorScheme.tableTextColor)
                    TextField("\(time)", text: $registeredTime)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onChange (of: registeredTime){
                            let filtered = registeredTime.filter { "0123456789".contains($0) }
                            if filtered.count > 4 {
                                registeredTime = String(filtered.prefix(4))
                            } else if filtered.count == 4 && !filtered.contains(":") {
                                let timeWithSeparator = filtered.inserting(separator: ":", every: 2)
                                registeredTime = validateAndCorrectTime(time: timeWithSeparator)
                            } else {
                                registeredTime = filtered
                            }
                        }
                        .padding(5)
                        .background(ColorScheme.fieldBgColor)
                        .cornerRadius(7)
                        .frame(minWidth: 58, maxWidth: 60)
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
                    Toggle(isOn: $dayOff) {
                        Text("")
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
                    Toggle(isOn: $doctor) {
                        Text("")
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
                    } else if registeredTime.count != 5 {
                        errorMessage = "ⓘ Insira um horário válido"
                    } else {
                        errorMessage = ""
                        editSelectedEvent(event, justification, registeredTime)
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
    
    func editSelectedEvent(_ event: ClockEvent, _ justification: String, _ timestamp: String) {
        let id = event.id
        let justification = justification
        let timestamp = replaceTimeInTimestamp(originalTimestamp: event.timestamp, newTime: timestamp)
        
        if case let .loggedIn(token, _, _) = sessionManager.session {
            editClockEvent(id, timestamp, justification, token){ (message, error) in
                if let message = message {
                    DispatchQueue.main.async {
                        alertMessage = message
                        showingAlert = true
                        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)
                        let endDate = functionFormatter.string(from: tomorrowDate!)
                        let startDate = functionFormatter.string(from: startDate)
                        fetchUpdatedClockReport(startDate, endDate)
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
    
    func replaceTimeInTimestamp(originalTimestamp: String, newTime: String) -> String {
        let timeIndex = originalTimestamp.index(originalTimestamp.startIndex, offsetBy: 11)
        let datePart = originalTimestamp[..<timeIndex]
        return "\(datePart)\(newTime):00"
    }
    
    func fetchUpdatedClockReport(_ startDate: String, _ endDate: String) {
        if case let .loggedIn(token, id, _) = sessionManager.session {
            getClockEntriesByPeriod(id, token, startDate: startDate, endDate: endDate) { (clockReport, error) in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleEvent: ClockEvent
        @State var clockReport: ClockReport?
        @State var endDate = Date()
        @State var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        do {
            let url = Bundle.main.url(forResource: "EventExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddHHmmss)
            exampleEvent = try decoder.decode(ClockEvent.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            exampleEvent = ClockEvent(id: 0, timestamp: "", type: "", justification: nil)
        }
        return NavigationView {
            EditEventView(event: exampleEvent, clockReport: $clockReport, startDate: $startDate, endDate: $endDate)
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
