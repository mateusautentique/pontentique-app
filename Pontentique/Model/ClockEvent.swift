//
//  ClockEvent.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import Foundation

struct ClockEvent: Codable, Identifiable, Hashable {
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
    
    init(id: Int, timestamp: String, type: String, justification: String?) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self._justification = justification
    }
}
