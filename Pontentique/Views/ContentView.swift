//
//  ContentView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @EnvironmentObject var sessionInfo: SessionInfo
    

    var body: some View {
        NavigationStack {
            if isAuthenticated {
                MainPanel(isAuthenticated: $isAuthenticated).environmentObject(sessionInfo)
            } else {
                LoginScreen(isAuthenticated: $isAuthenticated).environmentObject(sessionInfo)
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(SessionInfo(session: ""))
}

