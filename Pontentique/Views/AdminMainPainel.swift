//
//  UserMainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct AdminMainPanel: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var isLoggedIn = false
    //MARK: - CLOCK INFO
    @State private var clockReport = ClockReport()
    @ObservedObject var dataFetcher = DataFetcher()
    
    //MARK: - ERROR INFO
    @State private var errorMessage: String?
    
    //MARK: - DATE INFO
    @State private var endDate = Date()
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    
    //MARK: - ALERT
    enum ActiveAlert { case first, second }
    @State private var activeAlert: ActiveAlert = .first
    @State private var showAlert: Bool = false
    @State private var sucessPunchMessage: String = ""
    //MARK: - VIEW VARIABLES
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - VIEW
    var body: some View {
    //MARK: MYHOUR FORMATTER
        let myHour = Text(Date(), formatter: createFormatter("HH:mm"))
            .font(.system(size: 330))
    //MARK: USERNAME AND BUTTONS
        NavigationStack{
            VStack {
                HStack {
                    ZStack{
                        HStack{
                            Button(action: {
                                //Coloque aqui a acão do botão da esquerda
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24))
                            }
                            Spacer()
                            
                            Button(action: {
                                //Coloque aqui a acão do botão da direita
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 24))
                            }
                        }
                        .padding()
                        Text("USERNAME(0¯0)")
                            .font(.system(size: 28))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
        //MARK: DATE
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
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                        .padding(.leading)
                        
                        Text("\(startDate, formatter: createFormatter("dd/MM/yy")) - \(endDate, formatter: createFormatter("dd/MM/yy"))")
                            .font(.system(size: 28))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                }
                Spacer()
                Spacer()
        //MARK: "DATA", "REGISTROS", "BANCO"
                HStack{
                    Text("DATA")
                        .padding(.trailing, 6)
                        .padding(.leading, 8)
                    Text("REGISTROS")
                        .padding(.leading, 2)
                    Spacer()
                    Text("BANCO")
                        .padding(.trailing, 6)
                }
                
                .foregroundColor(ColorScheme.tableTextColor)
                .background(ColorScheme.appBackgroudColor)
                .fontWeight(.semibold)
                .padding(.bottom, 15)
                
                ScrollView {
                    ForEach(clockReport.entries) { entry in
                        ClockTableRow(clockEntry: entry, clockReport: clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: refreshReport)
                    }
                }
        //MARK: "BANCO TOTAL"
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
        //MARK: REGISTER THE CLOCKEVENT AND ALERT
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
                            if let user = sessionManager.user {
                                punchClock(user.id, user.token ?? "") { (message, error) in
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
            
            //MARK: 3 BUTTONS
            HStack {
                Spacer()
                Button(action: {
                    // Ação do botão 1
                }) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                Spacer()
                Button(action: {
                    //Ação do botão 2
                }) {
                    Image(systemName: "list.bullet.clipboard")
                        .foregroundColor(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                Spacer()
                Button(action: {
                    // Ação do botão 3
                }) {
                    Image(systemName: "person.2")
                        .foregroundColor(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }

                Spacer()
            }
            
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(ColorScheme.clockBtnBgColor)
        }
        
        .onAppear {
            refreshReport()
        }
    }
    
    //MARK: - UPDATE VIEW
    func refreshReport() {
        let endDate = createFormatter("yyyy-MM-dd").string(from: endDate)
        let startDate = createFormatter("yyyy-MM-dd").string(from: startDate)
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
struct AdminMainPanel_Previews: PreviewProvider {
    static var previews: some View {
        AdminMainPanel()
            .environmentObject(UserSessionManager())
    }
}
