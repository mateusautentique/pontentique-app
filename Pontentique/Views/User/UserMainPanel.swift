//
//  UserMainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct UserMainPanel: View {
    //USER INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //CLOCK INFO
    @StateObject var clockReportController = ClockReportController()
    
    //DATE VARIABLES
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var currentDate: String {
        formatter.string(from: Date())
    }
    
    var weekAgoDate: String {
        let sevenDaysAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        return formatter.string(from: sevenDaysAgo)
    }
    
    //VIEW VARIABLES
    @Environment(\.presentationMode) var presentationMode
    
    //VIEW
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
                
                ForEach(clockReportController.clockReport?.entries ?? []) { entry in
                    ClockTableRow(clockEntry: entry)
                        .padding(.bottom, 15)
                }
                
                HStack {
                    Spacer()
                    Text("BANCO TOTAL")
                        .padding(.trailing, 20)
                        .foregroundColor(ColorScheme.tableTextColor)
                    BalanceValue(balanceHours: clockReportController.clockReport?.totalHourBalance ?? "")
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
                    //Mostrar popup e confirmar batida
                    if case let .loggedIn(token, id, name) = sessionManager.session {
                        print("User name: \(name), ID: \(id), Token: \(token)")
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
                Text("\(weekAgoDate) - \(currentDate)")
                    .font(.system(size: 25))
            }
        )
        .padding(.bottom, 15)
    }
}


//PREVIEW
struct UserMainPanel_Previews: PreviewProvider {
    static var previews: some View {
        UserMainPanel()
            .environmentObject(ClockReportController())
            .environmentObject(UserSessionManager())
    }
}
