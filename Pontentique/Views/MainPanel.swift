//
//  MainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct MainPanel: View {
    @Binding var isAuthenticated: Bool
    @EnvironmentObject var sessionInfo: SessionInfo
    
    var body: some View {
        NavigationStack {
            if !isAuthenticated {
                LoginScreen(isAuthenticated: $isAuthenticated)
            } else {
                Button(action: {
                    Task {
                        do {
                            try await userLogout(sessionInfo.session)
                            isAuthenticated = false
                        } catch {
                            print("An error occurred: \(error)")
                        }
                    }
                }) {
                    Text("Logout")
                }
            }
        }
    }
}

#Preview {
    MainPanel(isAuthenticated: .constant(true))
}
