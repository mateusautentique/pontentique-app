//
//  LoginInfo.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import Foundation

class UserInfo: Codable, ObservableObject{
    var token: String?
    var id: Int
    var name: String
    var sessionIsValid: Bool = false
}
