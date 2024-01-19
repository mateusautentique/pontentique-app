//
//  ContentView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    
    var body: some View {
        NavigationView {
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
}

#Preview {
    ContentView()
        .environmentObject(UserSessionManager())
}
