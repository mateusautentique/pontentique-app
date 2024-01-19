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
            VStack(alignment: .leading) {
                ForEach(Array(chunks.enumerated()), id: \.offset) { index, chunk in
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(chunk) { event in
                            EventLinkView(event: event, clockReport: clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: onEventEdited)
                                .padding(7)
                                .frame(width: 60)
                                .fixedSize()
                                .background(isToday(event.timestamp) ? ColorScheme.BacktodaysColor : ColorScheme.clockBtnBgColor)
                                .foregroundColor(isToday(event.timestamp) ? ColorScheme.todaysColor : ColorScheme.textColor)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(event.justification != "" ? Color.gray : .clear, lineWidth: 1)
                                )
                                .padding(.trailing, 5)
                        }
                        if index == chunks.indices.last && chunk.count < 4 {
                            AddEvent()
                                
                        }
                    }
                    .padding(.bottom, index < chunks.count - 1 ? 7 : 0)
                }
                // Check if you need to add the AddEvent button on a new line.
                if let lastChunk = chunks.last, lastChunk.count == 4 {
                    AddEvent()
                        
                }
            }
        }
    }


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
