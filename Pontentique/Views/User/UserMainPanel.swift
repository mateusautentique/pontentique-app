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
    
    var currentDate: Date {
        return Date()
    }

    var weekAgoDate: Date {
        return Date().addingTimeInterval(-7 * 24 * 60 * 60)
    }
    
    //MARK: - CLOCK INFO
    @State private var clockReport: ClockReport?
    
    //MARK: - VIEW VARIABLES
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - VIEW
    var body: some View {
        NavigationStack{
            VStack {
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
                
                ForEach(clockReport?.entries ?? []) { entry in
                    ClockTableRow(clockEntry: entry)
                        .padding(.bottom, 15)
                }
                
                HStack {
                    Spacer()
                    Text("BANCO TOTAL")
                        .padding(.trailing, 20)
                        .foregroundColor(ColorScheme.tableTextColor)
                    BalanceValue(balanceHours: clockReport?.totalHourBalance ?? "")
                        .bold()
                        .frame(width: 60)
                        .padding(.trailing, 6)
                    
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(ColorScheme.clockBtnBgColor)
                .padding(.top, 10)
                
                Spacer()
                
                Button(action: {
                    //Mostrar popup
                    if case let .loggedIn(token, id, _) = sessionManager.session {
                        punchClock(id, token) { (message, error) in
                            if let message = message {
                                DispatchQueue.main.async {
                                    print(message)
                                }
                            } else if let error = error {
                                print(error)
                            }
                        }
                    }
                }) {
                    Text("Registrar ponto")
                        .bold()
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(ColorScheme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
            }
            .background(ColorScheme.appBackgroudColor)
            .padding(.top, 15)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(ColorScheme.primaryColor)
                }
                Text("\(textFormatter.string(from: weekAgoDate)) - \(textFormatter.string(from: currentDate))")
                    .font(.system(size: 25))
            }
        )
        .padding(.bottom, 15)
        .onAppear {
            let endDate = functionFormatter.string(from: currentDate)
            let startDate = functionFormatter.string(from: weekAgoDate)
            fetchClockReport(startDate, endDate)
        }
    }
    
    func fetchClockReport(_ startDate: String, _ endDate: String) {
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
struct UserMainPanel_Previews: PreviewProvider {
    static var previews: some View {
        UserMainPanel()
            .environmentObject(UserSessionManager())
    }
}
