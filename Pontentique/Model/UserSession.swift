//
//  UserSession.swift
//  Pontentique
//
//  Created by Mateus Zanella on 15/12/23.
//

import Foundation

class SessionInfo: ObservableObject{
    @Published var sessionIsValid: Bool = false
}

class UserSession: Codable{
    static let shared = UserSession()
    
    var token: String?
    var id: Int?
    var name: String?
    
    private init() {}
}
