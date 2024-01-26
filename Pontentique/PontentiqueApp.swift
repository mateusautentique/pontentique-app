//
//  PontentiqueApp.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

let API_HOST = "http://localhost/api"

@main
struct PontentiqueApp: App {
    @StateObject var sessionManager = UserSessionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
        }
    }
}
