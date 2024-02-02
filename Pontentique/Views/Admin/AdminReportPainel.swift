//
//  UserMainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct AdminReportPanel: View {
    //MARK: - USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var isLoggedIn = false
    
    @State private var users = [User]()
    @State private var currentUserIndex = 0
    
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
    @State private var appIsFullyLoaded = false
    @State private var userColor: String?
    
    //MARK: - VIEW
    var body: some View {
        let myHour = Text(Date(), formatter: createFormatter("HH:mm"))
            .font(.system(size: 330))
        
        //MARK: USER
        NavigationStack{
            VStack {
                HStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                if currentUserIndex > 0 {
                                    currentUserIndex -= 1
                                } else {
                                    currentUserIndex = users.count - 1
                                }
                                refreshAdminReport()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if currentUserIndex < users.count - 1 {
                                    currentUserIndex += 1
                                } else {
                                    currentUserIndex = 0
                                }
                                refreshAdminReport()
                                
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 24))
                            }
                        }
                        .padding()
                        
                        Text(users.isEmpty ? "Carregando..." : users[currentUserIndex].name)
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
                                
                                refreshAdminReport()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24))
                            }
                            
                            Spacer()
                            
                            if !Calendar.current.isDate(endDate, equalTo: Date(), toGranularity: .day) {
                                Button(action: {
                                    startDate = Calendar.current.date(byAdding: .day, value: +7, to: startDate)!
                                    endDate = Calendar.current.date(byAdding: .day, value: +7, to: endDate)!
                                    
                                    refreshAdminReport()
                                }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 24))
                                }
                            }
                        }
                        .padding()
                        
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
                
                .foregroundStyle(ColorScheme.tableTextColor)
                .background(ColorScheme.appBackgroudColor)
                .fontWeight(.semibold)
                .padding(.bottom, 15)
                
                ScrollView {
                    if appIsFullyLoaded {
                        ForEach(clockReport.entries) { entry in
                            ClockTableRow(clockEntry: entry, clockReport: $clockReport,
                                          startDate: $startDate, endDate: $endDate,
                                          onEventEdited: refreshAdminReport)
                        }
                    } else {
                        LoadingIconView()
                    }
                }
                
                //MARK: "BANCO TOTAL"
                HStack {
                    Spacer()
                    Text("BANCO TOTAL")
                        .padding(.trailing, 20)
                        .foregroundStyle(ColorScheme.tableTextColor)
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
                        .foregroundStyle(.red)
                        .padding(.top, 10)
                }
                
                //MARK: REGISTER THE CLOCKEVENT AND ALERT
                VStack {
                    if appIsFullyLoaded, let currentUser = sessionManager.user, users[currentUserIndex].id == currentUser.id {
                        Button(action: {
                            //DEBUG
                            UserDefaults.standard.removeObject(forKey: "userToken")
                            //DEBUG
                            self.activeAlert = .first
                            showAlert = true
                        }) {
                            Text("Registrar ponto")
                                .bold()
                                .padding(15)
                                .frame(maxWidth: .infinity)
                                .background(ColorScheme.primaryColor)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
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
                                            refreshAdminReport()
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
        }
        .onAppear {
            getAllUsers {
                refreshAdminReport()
            }
        }
    }
    
    //MARK: - UPDATE VIEW
    func getAllUsers(completion: @escaping () -> Void) {
        dataFetcher.fetchAllUsers(sessionManager: sessionManager) { fetchedUsers, error in
            if let fetchedUsers = fetchedUsers {
                DispatchQueue.main.async {
                    self.users = fetchedUsers
                    if let currentUser = sessionManager.user {
                        self.currentUserIndex = self.users.firstIndex(where: { $0.id == currentUser.id }) ?? 0
                    }
                    completion()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func refreshAdminReport() {
        guard !users.isEmpty else { return }
        let selectedUser = users[currentUserIndex]
        let endDate = createFormatter("yyyy-MM-dd").string(from: endDate)
        let startDate = createFormatter("yyyy-MM-dd").string(from: startDate)
        dataFetcher.fetchClockReport(startDate, endDate, sessionManager: sessionManager, selectedUser: selectedUser) { fetchedClockReport, error in
            if let fetchedClockReport = fetchedClockReport {
                DispatchQueue.main.async {
                    self.clockReport = fetchedClockReport
                    self.appIsFullyLoaded = true
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

//MARK: - PREVIEW
struct AdminReportPanel_Previews: PreviewProvider {
    static var previews: some View {
        AdminMainPanel()
            .environmentObject(UserSessionManager())
    }
}
