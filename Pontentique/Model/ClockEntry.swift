//
//  ClockEntry.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import Foundation

struct ClockEntry: Codable, Identifiable{
    let day: String
    let normalHoursWorkedOnDay: String
    let extraHoursWorkedOnDay: String
    let balanceHoursOnDay: String
    let totalTimeWorkedInSeconds: Int
    let eventCount: Int
    let events: [ClockEvent]
    
    var id: String { day }
}


