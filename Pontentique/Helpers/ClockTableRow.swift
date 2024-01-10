//
//  ClockTableRow.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct ClockTableRow: View {
    //MARK: - VARIABLES
    @ObservedObject var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    @ObservedObject var clockEntry: ClockEntry
    
    let onEventEdited: () -> Void
    
    init(clockEntry: ClockEntry, clockReport: ClockReport, startDate: Binding<Date>, endDate: Binding<Date>, onEventEdited: @escaping () -> Void) {
        self.clockEntry = clockEntry
        self._clockReport = ObservedObject(initialValue: clockReport)
        self._startDate = startDate
        self._endDate = endDate
        self.onEventEdited = onEventEdited
    }
    
    var body: some View {
        NavigationStack {
            HStack (spacing: 0){
                DateText(date: clockEntry.day)
                EventGroup(clockEntry: clockEntry, clockReport: clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: self.onEventEdited)
                Spacer()
                BalanceValue(balanceHours: $clockEntry.balanceHoursOnDay)
                    .bold()
                    .padding(.leading, 5)
                    .padding(.trailing, 6)
                    .frame(width: 60)
            }
            .background(ColorScheme.appBackgroudColor)
        }
    }
}


//MARK: - UTILS
func isWeekday(_ dateString: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: dateString) else {
        return false
    }
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    return !(weekday == 1 || weekday == 7)
}

func isEventToday(_ dateString: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: dateString) else {
        return false
    }
    let comparisonResult = Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day)
    return comparisonResult
}

func isToday(_ timestamp: String) -> Bool {
    guard let eventDate = convertToDate(timestamp) else {
        return false
    }
    let comparisonResult = Calendar.current.isDate(eventDate, equalTo: Date(), toGranularity: .day)
    return comparisonResult
}

func convertToDate(_ timestamp: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.date(from: timestamp)
}

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
        return "Invalid time"
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

extension DateFormatter {
    static let yyyyMMddHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

extension Array {
    func chunks(of size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}


//MARK: - PREVIEW
struct ClockTableRow_Previews: PreviewProvider {
    static var previews: some View {
        let clockEntry: ClockEntry
        @State var clockReport: ClockReport? = ClockReport()
        @State var endDate = Date()
        @State var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
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
        
        return ClockTableRow(clockEntry: clockEntry, clockReport: clockReport!, startDate: $startDate, endDate: $endDate, onEventEdited: {
            //DEBUG
        })
    }
}
