//
//  UserMainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct UserMainPanel: View {
    let clockReport: ClockReport

    init(clockReport: ClockReport) {
        self.clockReport = clockReport
    }
    
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
                .foregroundColor(ColorScheme.textColor)
                .background(ColorScheme.appBackgroudColor)

                
                ForEach(clockReport.entries) { entry in
                    ClockTableRow(clockEntry: entry)
                }
                .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    Text("BANCO TOTAL")
                        .padding(.trailing, 20)
                    BalanceValue(balanceHours: clockReport.totalHourBalance)
                        .bold()
                        .padding(.trailing, 6)
                        .frame(width: 60)

                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(ColorScheme.fieldBgColorDark)
                
                Spacer()
            }
            .background(ColorScheme.appBackgroudColor)
        }
    }
}

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
