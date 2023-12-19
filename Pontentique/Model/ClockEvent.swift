//
//  ClockEvent.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import Foundation

struct ClockEvent: Codable, Identifiable{
    let id: Int
    let timestamp: String
    let justification: String
    let type: String
    
//    init(id: Int, timestamp: String, justification: String?, type: String) {
//        self.id = id
//        self.timestamp = timestamp
//        self.justification = justification ?? ""
//        self.type = type
//    }
}
