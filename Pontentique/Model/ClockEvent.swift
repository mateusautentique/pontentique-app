//
//  ClockEvent.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import Foundation

struct ClockEvent: Codable, Identifiable {
    let id: Int
    let timestamp: String
    let type: String
    private let _justification: String?

    var justification: String {
        return _justification ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id, timestamp, type
        case _justification = "justification"
    }
}
