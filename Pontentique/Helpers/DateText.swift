//
//  DateText.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import SwiftUI

struct DateText: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    @ObservedObject var clockEntry: ClockEntry
    @Binding var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    var date: String
    
    let onEventEdited: () -> Void
    
    init(clockEntry: ClockEntry, clockReport: Binding<ClockReport>, startDate: Binding<Date>, endDate: Binding<Date>, date: String, onEventEdited: @escaping () -> Void) {
        self.clockEntry = clockEntry
        self._clockReport = clockReport
        self._startDate = startDate
        self._endDate = endDate
        self.onEventEdited = onEventEdited
        self.date = date
    }
    
    var body: some View {
        NavigationLink(destination: sessionManager.user?.role == "admin" ? AdminAddEventDateView(clockEntry: clockEntry, clockReport: $clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: onEventEdited) : nil) {
            Text(dateFormat(date))
                .foregroundColor(isEventToday(date) ? ColorScheme.todaysColor : ColorScheme.tableTextColor)
                .padding(.leading, 6)
                .padding(.trailing, 10)
                .frame(width: 65)
        }
    }
}

//struct DateText_Previews: PreviewProvider {
//    static var previews: some View {
//        DateText(clockEntry: ClockEntry(), clockReport: .constant(ClockReport()), startDate: .constant(Date()), endDate: .constant(Date()), date: "2023-01-01", onEventEdited: {})
//            .environmentObject(UserSessionManager())
//    }
//}

