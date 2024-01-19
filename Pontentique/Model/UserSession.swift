//
//  UserSession.swift
//  Pontentique
//
//  Created by Mateus Zanella on 15/12/23.
//

import Foundation

enum UserSession {
    case loggedIn(User)
    case loggedOut
    
    static var current: UserSession {
        get {
            if let data = UserDefaults.standard.data(forKey: "user") {
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(User.self, from: data) {
                    return .loggedIn(user)
                }
            }
            return .loggedOut
        }
        set {
            switch newValue {
            case .loggedIn(let user):
                let encoder = JSONEncoder()
                if let data = try? encoder.encode(user) {
                    UserDefaults.standard.set(data, forKey: "user")
                }
            case .loggedOut:
                UserDefaults.standard.removeObject(forKey: "user")
            }
        }
    }
}
