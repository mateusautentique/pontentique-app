//
//  UserMainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct UserMainPanel: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - DATE VARIABLES
    let textFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    let functionFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    //MARK: - CLOCK INFO
    @State private var clockReport = ClockReport()
    @ObservedObject var dataFetcher = DataFetcher()

    //MARK: - ERROR INFO
    @State private var errorMessage: String?
    
    //MARK: - DATE INFO
    @State private var endDate = Date()
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
    
    //MARK: - ALERT
    enum ActiveAlert { case first, second }
    @State private var activeAlert: ActiveAlert = .first
    @State private var showAlert: Bool = false
    @State private var sucessPunchMessage: String = ""
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    //MARK: - VIEW VARIABLES
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - VIEW
    var body: some View {
        let myHour = Text(Date(), formatter: timeFormatter)
            .font(.system(size: 330))
        NavigationStack{
            VStack {
                HStack {
                    ZStack{
                        HStack{
                            Button(action: {
                                startDate = Calendar.current.date(byAdding: .day, value: -7, to: startDate)!
                                endDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
                                
                                refreshReport()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24))
                            }
                            Spacer()
                            if !Calendar.current.isDate(endDate, equalTo: Date(), toGranularity: .day) {
                                Button(action: {
                                    startDate = Calendar.current.date(byAdding: .day, value: +7, to: startDate)!
                                    endDate = Calendar.current.date(byAdding: .day, value: +7, to: endDate)!
                                    
                                    refreshReport()
                                }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 24))
                                }
                            }
                        }
                        .padding()
                        
                        Text("\(startDate, formatter: dateFormatter) - \(endDate, formatter: dateFormatter)")
                            .font(.system(size: 28))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                HStack{
                    Text("DATA")
                        .padding(.trailing, 6)
                        .padding(.leading, 8)
                    Text("REGISTROS")
                    Spacer()
                    Text("BANCO")
                        .padding(.trailing, 6)
                }
                .foregroundColor(ColorScheme.tableTextColor)
                .background(ColorScheme.appBackgroudColor)
                .fontWeight(.semibold)
                .padding(.bottom, 15)
                
                ForEach(clockReport.entries) { entry in
                    ClockTableRow(clockEntry: entry, clockReport: clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: refreshReport)
                }
                
                HStack {
                    Spacer()
                    Text("BANCO TOTAL")
                        .padding(.trailing, 20)
                        .foregroundColor(ColorScheme.tableTextColor)
                    BalanceValue(balanceHours: $clockReport.totalHourBalance)
                        .bold()
                        .frame(width: 60)
                        .padding(.trailing, 6)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(ColorScheme.clockBtnBgColor)
                .padding(.top, 10)
                
                Spacer()
                
                if let errorMessage = errorMessage {
                    Text("\(errorMessage)")
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                              
                VStack {
                    Button(action: {
                        self.activeAlert = .first
                        showAlert = true
                    }) {
                        Text("Registrar ponto")
                            .bold()
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .background(ColorScheme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .first:
                        return Alert(title: Text("Gerar registro de ponto"), message: Text("Tem certeza que você gostaria de registrar o ponto? Ele será registrado às\n \(myHour)"), primaryButton: .default(Text("Registrar"), action: {
                            if case let .loggedIn(token, id, _) = sessionManager.session {
                                punchClock(id, token) { (message, error) in
                                    if let message = message {
                                        DispatchQueue.main.async {
                                            refreshReport()
                                            
                                            sucessPunchMessage = message
                                            self.activeAlert = .second
                                            showAlert = true
                                        }
                                    } else if let error = error {
                                        errorMessage = "ⓘ \(error.localizedDescription)"
                                    }
                                }
                            }
                        }), secondaryButton: .cancel())
                    case .second:
                        return Alert(title: Text("Successo!"), message: Text(sucessPunchMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .padding()
            }
            .background(ColorScheme.appBackgroudColor)
            .padding(.top, 15)
        }
        .padding(.bottom, 15)
        .onAppear {
            refreshReport()
        }
    }
    
    func refreshReport() {
        let endDate = functionFormatter.string(from: endDate)
        let startDate = functionFormatter.string(from: startDate)
        dataFetcher.fetchClockReport(startDate, endDate, sessionManager: sessionManager) { fetchedClockReport in
            if let fetchedClockReport = fetchedClockReport {
                DispatchQueue.main.async {
                    self.clockReport = fetchedClockReport
                }
            }
        }
    }
}

//MARK: - PREVIEW
struct UserMainPanel_Previews: PreviewProvider {
    static var previews: some View {
        UserMainPanel()
            .environmentObject(UserSessionManager())
    }
}
