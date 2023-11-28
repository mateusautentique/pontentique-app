//
//  LoginInfo.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import Foundation

struct SessionInfo: Codable{
    var session: String
}

struct SessionValidationResponse: Codable {
    let sessionIsValid: Bool
}

