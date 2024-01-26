//
//  ClockReport.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import Foundation

class ClockReport: ObservableObject, Codable {
    let userId: Int
    let userName: String
    let totalHoursWorked: String
    let totalNormalHoursWorked: String
    @Published var totalHourBalance: String
    var entries: [ClockEntry]

    enum CodingKeys: CodingKey {
        case userId, userName, totalHoursWorked, totalNormalHoursWorked, totalHourBalance, entries
    }
    
    init() {
        self.userId = 0
        self.userName = ""
        self.totalHoursWorked = ""
        self.totalNormalHoursWorked = ""
        self.totalHourBalance = ""
        self.entries = []
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .userId)
        userName = try container.decode(String.self, forKey: .userName)
        totalHoursWorked = try container.decode(String.self, forKey: .totalHoursWorked)
        totalNormalHoursWorked = try container.decode(String.self, forKey: .totalNormalHoursWorked)
        totalHourBalance = try container.decode(String.self, forKey: .totalHourBalance)
        entries = try container.decode([ClockEntry].self, forKey: .entries)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(userName, forKey: .userName)
        try container.encode(totalHoursWorked, forKey: .totalHoursWorked)
        try container.encode(totalNormalHoursWorked, forKey: .totalNormalHoursWorked)
        try container.encode(totalHourBalance, forKey: .totalHourBalance)
        try container.encode(entries, forKey: .entries)
    }
}

