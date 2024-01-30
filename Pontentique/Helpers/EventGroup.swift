//
//  EventGroup.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import SwiftUI

struct EventGroup: View {
    var clockEntry: ClockEntry
    @ObservedObject var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    let onEventEdited: () -> Void
    
    init(clockEntry: ClockEntry, clockReport: ClockReport, startDate: Binding<Date>, endDate: Binding<Date>, onEventEdited: @escaping () -> Void) {
        self.clockEntry = clockEntry
        self._clockReport = ObservedObject(initialValue: clockReport)
        self._startDate = startDate
        self._endDate = endDate
        self.onEventEdited = onEventEdited
    }
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 0) {
                if !clockEntry.events.isEmpty {
                    EventChunkView(clockEntry: clockEntry, clockReport: clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: self.onEventEdited)
                } else if isWeekday(clockEntry.day) {
                    HStack(spacing: 0) {
                        AbsenceView()
                            .padding(.trailing, 5)
                        AddEventLinkView(clockReport: clockReport, clockEntry: clockEntry,
                                         startDate: $startDate, endDate: $endDate,
                                         onEventEdited: self.onEventEdited)
                    }
                } else {
                    HStack(spacing: 0) {
                        WeekendView()
                            .padding(.trailing, 5)
                        AddEventLinkView(clockReport: clockReport, clockEntry: clockEntry,
                                         startDate: $startDate, endDate: $endDate,
                                         onEventEdited: self.onEventEdited)
                    }
                }
            }
        }
        .padding(0)
        .frame(alignment: .leading)
    }
}

struct EventGroup_Previews: PreviewProvider {
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
            decoder.dateDecodingStrategy = .formatted(createFormatter("yyyy-MM-dd HH:mm:ss"))
            clockEntry = try decoder.decode(ClockEntry.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            clockEntry = ClockEntry(day: "", normalHoursWorkedOnDay: "", extraHoursWorkedOnDay: "", balanceHoursOnDay: "", totalTimeWorkedInSeconds: 0, eventCount: 0, events: [])
        }
        
        return EventGroup(clockEntry: clockEntry, clockReport: clockReport!, startDate: $startDate, endDate: $endDate, onEventEdited: {
            //DEBUG
        })
    }
}
