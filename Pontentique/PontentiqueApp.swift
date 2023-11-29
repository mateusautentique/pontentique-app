//
//  PontentiqueApp.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

@main
struct PontentiqueApp: App {
    @StateObject var sessionInfo = SessionInfo(session: "")
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(sessionInfo)
        }
    }
}
