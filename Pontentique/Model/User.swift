//
//  User.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/01/24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let cpf: String
    let email: String
    let role: String
    let workJourneyHours: Int
    let createdAt: Date
    let updatedAt: Date
    var token: String?
}
