//
//  Ticket.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/01/24.
//

import Foundation

import Foundation

struct Ticket: Codable, Identifiable {
    let id: Int
    let userId: Int
    let userName: String
    let type: String
    let justification: String
    let clockEventId: Int?
    let clockEventTimestamp: String?
    let status: String
    let createdAt: String?
    let updatedAt: String?
    var requestedData: RequestedData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case userName = "user_name"
        case clockEventId = "clock_event_id"
        case clockEventTimestamp = "clock_event_timestamp"
        case type
        case status
        case justification
        case requestedData = "requested_data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        userId = try container.decode(Int.self, forKey: .userId)
        userName = try container.decode(String.self, forKey: .userName)
        type = try container.decode(String.self, forKey: .type)
        justification = try container.decode(String.self, forKey: .justification)
        clockEventId = try container.decodeIfPresent(Int.self, forKey: .clockEventId)
        clockEventTimestamp = try container.decodeIfPresent(String.self, forKey: .clockEventTimestamp)
        status = try container.decode(String.self, forKey: .status)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        requestedData = try container.decodeIfPresent(RequestedData.self, forKey: .requestedData)
    }
}

struct TicketRequest: Codable {
    let userId: Int
    let type: String
    let clockEventId: Int?
    let justification: String
    let requestedData: RequestedData?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case type
        case justification
        case clockEventId = "clock_event_id"
        case requestedData = "requested_data"
    }
}

struct RequestedData: Codable {
    let userId: Int
    let timestamp: String
    let justification: String
    let dayOff: Bool
    let doctor: Bool

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case timestamp
        case justification
        case dayOff = "day_off"
        case doctor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            userId = try container.decode(Int.self, forKey: .userId)
        } catch DecodingError.typeMismatch {
            let userIdString = try container.decode(String.self, forKey: .userId)
            userId = Int(userIdString) ?? 0
        }

        timestamp = try container.decode(String.self, forKey: .timestamp)
        justification = try container.decode(String.self, forKey: .justification)

        do {
            let dayOffInt = try container.decode(Int.self, forKey: .dayOff)
            dayOff = dayOffInt == 1
        } catch DecodingError.typeMismatch {
            let dayOffString = try container.decode(String.self, forKey: .dayOff)
            dayOff = dayOffString == "1"
        }

        do {
            let doctorInt = try container.decode(Int.self, forKey: .doctor)
            doctor = doctorInt == 1
        } catch DecodingError.typeMismatch {
            let doctorString = try container.decode(String.self, forKey: .doctor)
            doctor = doctorString == "1"
        }
    }
    
    init(userId: Int, timestamp: String, justification: String, dayOff: Bool, doctor: Bool) {
        self.userId = userId
        self.timestamp = timestamp
        self.justification = justification
        self.dayOff = dayOff
        self.doctor = doctor
    }
}
