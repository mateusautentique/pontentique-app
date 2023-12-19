//
//  UserMainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct UserMainPanel: View {
    //CLOCK INFO
    let clockReport: ClockReport
    
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

    init(clockReport: ClockReport) {
        self.clockReport = clockReport
    }
    
    //VIEW
    var body: some View {
        NavigationStack{
            
            
            VStack {
                Text("\(weekAgoDate) - \(currentDate)")
                    .padding(10)
                    .fontWeight(.semibold)
                
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
                    ClockTableRow(clockEntry: entry)
                        .padding(.bottom, 4)
                }
                .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    Text("BANCO TOTAL")
                        .padding(.trailing, 20)
                        .foregroundColor(ColorScheme.tableTextColor)
                    BalanceValue(balanceHours: clockReport.totalHourBalance)
                        .bold()
                        .padding(.trailing, 6)
                        .frame(width: 60)

                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(ColorScheme.clockBtnBgColor)
                
                Spacer()
                
                Button(action: {
                    //Mostrar popup e confirmar batida
                    print("BONG BONG BONG")
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
        }
    }
}

//PREVIEW
struct UserMainPanel_Previews: PreviewProvider {
    static var previews: some View {
        let clockReport: ClockReport
        do {
            let url = Bundle.main.url(forResource: "ReportExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddHHmmss)
            clockReport = try decoder.decode(ClockReport.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            clockReport = ClockReport(userId: 1, userName: "", totalHoursWorked: "", totalNormalHoursWorked: "", totalHourBalance: "", entries: [])
        }
        
        return UserMainPanel(clockReport: clockReport)
    }
}
