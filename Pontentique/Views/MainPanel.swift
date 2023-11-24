//
//  MainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct MainPanel: View {
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        NavigationStack {
            if !isAuthenticated {
                LoginScreen(isAuthenticated: $isAuthenticated)
            } else {
                Button(action: {
                    self.isAuthenticated = false
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
