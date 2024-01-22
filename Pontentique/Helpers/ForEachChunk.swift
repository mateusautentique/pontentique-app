//
//  ForEachChunk.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 19/01/24.
//

import SwiftUI

struct ForEachChunk: View {
    var event: ClockEvent
    @ObservedObject var clockReport: ClockReport
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    let onEventEdited: () -> Void

    var body: some View {
        
            EventLinkView(event: event, clockReport: clockReport, startDate: $startDate, endDate: $endDate, onEventEdited: self.onEventEdited)
                .padding(7)
                .frame(width: 60)
                .fixedSize()
                .modifier(EventBackgroundColor(event: event))
                .modifier(EventForegroundColor(event: event))
                .cornerRadius(10)
                .overlay(
                    Group {
                        if event.justification != "" {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        }
                    }
                )
            .padding(.trailing, 5)
    }
}

