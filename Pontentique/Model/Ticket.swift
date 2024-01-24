//
//  Ticket.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/01/24.
//

import Foundation

struct Ticket: Codable {
    let id: Int
    let userId: Int
    let type: String
    let justification: String
    let clockEventId: Int?
    let status: String
    let createdAt: String?
    let updatedAt: String?
    let requestedData: RequestedData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case clockEventId = "clock_event_id"
        case type
        case status
        case justification
        case requestedData = "requested_data"
    }
}

struct RequestedData: Codable {
    let userId: Int
    let timestamp: String
    let justification: String
    let dayOff: Int
    let doctor: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case timestamp
        case justification
        case dayOff = "day_off"
        case doctor
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
