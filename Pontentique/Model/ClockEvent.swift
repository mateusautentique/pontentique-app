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
}
