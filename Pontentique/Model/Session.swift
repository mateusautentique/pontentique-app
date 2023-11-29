//
//  LoginInfo.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import Foundation

class SessionInfo: Codable, ObservableObject{
    var session: String
    
    init(session: String) {
        self.session = session
    }
}

struct SessionValidationResponse: Codable{
    let sessionIsValid: Bool
}
