//
//  ClockTableRow.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct ClockTableRow: View {
    let clockEntry: ClockEntry

    init(clockEntry: ClockEntry) {
        self.clockEntry = clockEntry
    }

    var body: some View {
        HStack (spacing: 0){
            Text(dateFormat(clockEntry.day))
                .foregroundColor(ColorScheme.tableTextColor)
                .padding(.leading, 6)
                .padding(.trailing, 10)
                .frame(width: 60)
            ForEach(clockEntry.events) {event in
                Text(timeFormat(event.timestamp))
                    .padding(7)
                    .background(ColorScheme.clockBtnBgColor)
                    .foregroundColor(ColorScheme.textColor)
                    .cornerRadius(10)
                    .frame(width: 60)
                    .frame(height: 24)
                    .padding(.trailing, 4)
            }
            Spacer()
            BalanceValue(balanceHours: clockEntry.balanceHoursOnDay)
                .bold()
                .padding(.leading, 5)
                .padding(.trailing, 6)
                .frame(width: 60)
        }
        .background(ColorScheme.appBackgroudColor)
    }
}


//UTILS
func dateFormat(_ timestamp: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"

    if let date = inputFormatter.date(from: timestamp) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM"
        return outputFormatter.string(from: date)
    } else {
        return "Invalid date"
    }
}

func timeFormat(_ timestamp: String) -> (String) {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    if let date = inputFormatter.date(from: timestamp) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        return outputFormatter.string(from: date)
    } else {
        return "Invalid date"
    }
}

func checkBalanceValue(_ duration: String) -> Bool {
    let components = duration.split(separator: ":")
    if let hours = Int(components[0]), let minutes = Int(components[1]) {
        let totalMinutes = hours * 60 + minutes
        return totalMinutes >= 0
    } else {
        return false
    }
}

//PREVIEW
struct ClockTableRow_Previews: PreviewProvider {
    static var previews: some View {
        let clockEntry: ClockEntry
        do {
            let url = Bundle.main.url(forResource: "RowExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddHHmmss)
            clockEntry = try decoder.decode(ClockEntry.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            clockEntry = ClockEntry(day: "", normalHoursWorkedOnDay: "", extraHoursWorkedOnDay: "", balanceHoursOnDay: "", totalTimeWorkedInSeconds: 0, eventCount: 0, events: [])
        }

        return ClockTableRow(clockEntry: clockEntry)
    }
}

extension DateFormatter {
    static let yyyyMMddHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
