//
//  ContentView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sessionInfo = SessionInfo()
    
    var body: some View {
        NavigationView {
            if sessionInfo.isLoggedIn {
                UserMainPanel()
                    .environmentObject(ClockReportController())
            } else {
                LoginScreen()
            }
        }
    }
}

#Preview {
    ContentView()
}

