//
//  EventBackgroundColor.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 19/01/24.
//

import SwiftUI

struct EventBackgroundColor: ViewModifier {
    var event: ClockEvent

    func body(content: Content) -> some View {
        content
            .background(
                isToday(event.timestamp) ? ColorScheme.BacktodaysColor :
                ColorScheme.clockBtnBgColor
            )
    }
}

struct EventForegroundColor: ViewModifier {
    var event: ClockEvent

    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                isToday(event.timestamp) ? ColorScheme.todaysColor :
                ColorScheme.textColor
            )
    }
}

