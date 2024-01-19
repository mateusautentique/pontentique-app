//
//  ClockEntry.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import Foundation
class ClockEntry: Codable, Identifiable, ObservableObject{

    let day: String
    let normalHoursWorkedOnDay: String
    let extraHoursWorkedOnDay: String
    var balanceHoursOnDay: String
    let totalTimeWorkedInSeconds: Int
    let eventCount: Int
    let events: [ClockEvent]
    
    var id: String { day }
    
    
    init(day: String, normalHoursWorkedOnDay: String, extraHoursWorkedOnDay: String, balanceHoursOnDay: String, totalTimeWorkedInSeconds: Int, eventCount: Int, events: [ClockEvent]) {
        self.day = day
        self.normalHoursWorkedOnDay = normalHoursWorkedOnDay
        self.extraHoursWorkedOnDay = extraHoursWorkedOnDay
        self.balanceHoursOnDay = balanceHoursOnDay
        self.totalTimeWorkedInSeconds = totalTimeWorkedInSeconds
        self.eventCount = eventCount
        self.events = events
    }
}



