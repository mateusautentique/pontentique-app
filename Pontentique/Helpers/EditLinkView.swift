//
//  EditLinkView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 08/01/24.
//

import SwiftUI

struct EventLinkView: View {
    var event: ClockEvent
    @Binding var clockReport: ClockReport?
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        NavigationLink(destination: EditEventView(event: event, clockReport: $clockReport, startDate: $startDate, endDate: $endDate)) {
            Text(timeFormat(event.timestamp))
                .padding(7)
                .frame(width: 60)
                .fixedSize()
                .background(ColorScheme.clockBtnBgColor)
                .foregroundColor(ColorScheme.textColor)
                .cornerRadius(10)
                .padding(.trailing, 5)
        }
    }
}

struct EventLinkView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleEvent: ClockEvent
        do {
            let url = Bundle.main.url(forResource: "EventExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddHHmmss)
            exampleEvent = try decoder.decode(ClockEvent.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            exampleEvent = ClockEvent(id: 0, timestamp: "", type: "", justification: nil)
        }
        
        @State var clockReport: ClockReport?
        @State var endDate = Date()
        @State var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        return NavigationView {
            EventLinkView(event: exampleEvent, clockReport: $clockReport, startDate: $startDate, endDate: $endDate)
        }
    }
}
