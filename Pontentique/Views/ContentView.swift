//
//  ContentView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var checkingSession = true
    
    var body: some View {
        NavigationView {
            if checkingSession {
                LoadingLoginScreenView()
                    .background(ColorScheme.appBackgroudColor)
            } else {
                switch sessionManager.session {
                case .loggedIn:
                    Group {
                        if sessionManager.user?.role == "admin" { AdminMainPanel() }
                        else { UserMainPanel() }
                    }
                case .loggedOut:
                    LoginScreen()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                checkUserSession()
            }
        }
    }
    
    func checkUserSession() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            self.checkingSession = false
            return
        }
        getLoggedUser(token) { [self] (user, error) in
            DispatchQueue.main.async {
                if let user = user {
                    self.sessionManager.session = .loggedIn(user)
                }
                self.checkingSession = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSessionManager())
}
