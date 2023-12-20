//
//  UserSessionManager.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/12/23.
//

import Foundation

class UserSessionManager: ObservableObject {
    @Published var session: UserSession = .loggedOut

    var token: String? {
        if case let .loggedIn(token, _, _) = session {
            return token
        }
        return nil
    }

    var id: Int? {
        if case let .loggedIn(_, id, _) = session {
            return id
        }
        return nil
    }

    var name: String? {
        if case let .loggedIn(_, _, name) = session {
            return name
        }
        return nil
    }
}
