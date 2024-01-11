//
//  EventChunkView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import SwiftUI

struct EventChunkView: View {
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
        let chunks = clockEntry.events.chunks(of: 4)
        ForEach(chunks.indices, id: \.self) { index in
            let chunk = chunks[index]
            HStack(alignment: .top, spacing: 0) {
                ForEach(chunk) { event in
                    EventLinkView(event: event, clockReport: clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: self.onEventEdited)
                        .padding(7)
                        .frame(width: 60)
                        .fixedSize()
                        .background(
                            event.justification != "" ? Color.yellow.opacity(0.17) :
                                isToday(event.timestamp) ? ColorScheme.BacktodaysColor :
                                ColorScheme.clockBtnBgColor
                        )
                        .foregroundColor(
                            event.justification != "" ? Color.yellow :
                                isToday(event.timestamp) ? ColorScheme.todaysColor :
                                ColorScheme.textColor
                        )
                        .cornerRadius(10)
                        .padding(.trailing, 5)
                }
            }
            .padding(.bottom, index < chunks.count - 1 ? 7 : 0)
        }
    }}

struct EventChunkView_Previews: PreviewProvider {
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
        
        return EventChunkView(clockEntry: clockEntry, clockReport: clockReport!, startDate: $startDate, endDate: $endDate, onEventEdited: {
            //DEBUG
        })
    }
}
