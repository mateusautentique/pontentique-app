//
//  ContentView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false

    var body: some View {
        NavigationStack {
            if isAuthenticated {
                MainPanel(isAuthenticated: $isAuthenticated)
            } else {
                LoginScreen(isAuthenticated: $isAuthenticated)
            }
        }
    }
}

#Preview {
    ContentView()
}

