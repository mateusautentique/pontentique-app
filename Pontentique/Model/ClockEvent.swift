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
    var doctor: Bool
    var dayOff: Bool

    var justification: String {
        return _justification ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id, timestamp, type, doctor, dayOff
        case _justification = "justification"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        type = try container.decode(String.self, forKey: .type)
        _justification = try container.decodeIfPresent(String.self, forKey: ._justification)

        let doctorInt = try container.decode(Int.self, forKey: .doctor)
        doctor = doctorInt == 1

        let dayOffInt = try container.decode(Int.self, forKey: .dayOff)
        dayOff = dayOffInt == 1
    }
    
    init(id: Int, timestamp: String, type: String, _justification: String?, doctor: Bool, dayOff: Bool) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self._justification = _justification
        self.doctor = doctor
        self.dayOff = dayOff
    }
}
