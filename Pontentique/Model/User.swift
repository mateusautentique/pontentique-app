//
//  User.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/01/24.
//

import Foundation

struct User: Codable, Identifiable{
    let id: Int
    let name: String
    let cpf: String
    let email: String
    let role: String
    let workJourneyHours: Int
    let createdAt: Date
    let updatedAt: Date
    var token: String?
    
    
    init(id: Int = 0, name: String = "Default User", cpf: String = "00000000000", email: String = "default@email.com", role: String = "user", workJourneyHours: Int = 0, createdAt: Date = Date(), updatedAt: Date = Date(), token: String? = nil) {
        self.id = id
        self.name = name
        self.cpf = cpf
        self.email = email
        self.role = role
        self.workJourneyHours = workJourneyHours
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.token = token
    }
}
