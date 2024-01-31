//
//  AddEvent.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI

struct AddEventLinkView: View {
    @ObservedObject var clockReport: ClockReport
    @ObservedObject var clockEntry: ClockEntry
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    let onEventEdited: () -> Void
    
    @State private var isShowingAddEventView = false
    
    var body: some View {
        NavigationLink(destination: AddEventView(clockEntry: clockEntry, clockReport: Binding.constant(clockReport), startDate: $startDate, endDate: $endDate, onEventEdited: self.onEventEdited)){
            Image(systemName: "plus")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .foregroundColor(ColorScheme.textColor)
                .background(ColorScheme.clockBtnBgColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 0)
        }
    }
}

struct AddEventLinkView_Previews: PreviewProvider {
    static var previews: some View {
        @State var clockReport: ClockReport? = ClockReport()
        @State var endDate = Date()
        @State var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let clockEntry = ClockEntry(day: "", normalHoursWorkedOnDay: "", extraHoursWorkedOnDay: "", balanceHoursOnDay: "", totalTimeWorkedInSeconds: 0, eventCount: 0, events: [])
        
        do {
            let url = Bundle.main.url(forResource: "EventExampleData", withExtension: "json")!
            _ = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(createFormatter("yyyy-MM-dd HH:mm:ss"))
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return NavigationView {
            AddEventLinkView(clockReport: clockReport!, clockEntry: clockEntry, startDate: $startDate, endDate: $endDate, onEventEdited: {
                //DEBUG
            })
        }
    }
}
