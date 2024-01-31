//
//  UserSessionManager.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/12/23.
//

import Foundation

class UserSessionManager: ObservableObject {
      @Published var session: UserSession = .loggedOut

    var user: User? {
        if case let .loggedIn(user) = session {
            return user
        }
        return nil
    }
}
