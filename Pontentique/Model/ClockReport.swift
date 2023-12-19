//
//  ClockReport.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import Foundation

struct ClockReport: Codable {
    let userId: Int
    let userName: String
    let totalHoursWorked: String
    let totalNormalHoursWorked: String
    let totalHourBalance: String
    let entries: [ClockEntry]
}
