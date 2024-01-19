//
//  EditLinkView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 08/01/24.
//

import SwiftUI

struct EventLinkView: View {
    var event: ClockEvent
    @ObservedObject var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    let onEventEdited: () -> Void
    
    var body: some View {
        NavigationLink(destination: EditEventView(event: event, clockReport: Binding.constant(clockReport), startDate: $startDate, endDate: $endDate, onEventEdited: self.onEventEdited)) {
            Text(timeFormat(event.timestamp))
        }
    }
}

struct EventLinkView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleEvent: ClockEvent
        @State var clockReport: ClockReport? = ClockReport()
        @State var endDate = Date()
        @State var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        do {
            let url = Bundle.main.url(forResource: "EventExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(createFormatter("yyyy-MM-dd HH:mm:ss"))
            exampleEvent = try decoder.decode(ClockEvent.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            exampleEvent = ClockEvent(id: 0, timestamp: "", type: "", _justification: nil, doctor: false, dayOff: false)
        }
        
        return NavigationView {
            EventLinkView(event: exampleEvent, clockReport: clockReport!, startDate: $startDate, endDate: $endDate, onEventEdited: {
                //DEBUG
            })
        }
    }
}
