//
//  UserSession.swift
//  Pontentique
//
//  Created by Mateus Zanella on 15/12/23.
//

import Foundation

enum UserSession {
    case loggedIn(token: String, id: Int, name: String)
    case loggedOut
    
    static var current: UserSession {
        get {
            if let token = UserDefaults.standard.string(forKey: "token"),
               let id = UserDefaults.standard.object(forKey: "id") as? Int,
               let name = UserDefaults.standard.string(forKey: "name") {
                return .loggedIn(token: token, id: id, name: name)
            } else {
                return .loggedOut
            }
        }
        set {
            switch newValue {
            case .loggedIn(let token, let id, let name):
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(id, forKey: "id")
                UserDefaults.standard.set(name, forKey: "name")
            case .loggedOut:
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "id")
                UserDefaults.standard.removeObject(forKey: "name")
            }
        }
    }
}
