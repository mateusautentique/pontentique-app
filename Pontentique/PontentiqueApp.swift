//
//  PontentiqueApp.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

let API_HOST = "http://192.168.1.250:8000/api"

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

extension DateFormatter {
    static var appTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}
