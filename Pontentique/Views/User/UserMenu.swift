//
//  UserMenu.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/12/23.
//

import SwiftUI

struct UserMenu: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var clockReportController = ClockReportController()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: UserMainPanel().environmentObject(ClockReportController())
                ) {}
            }
        }
    }
}

#Preview {
    UserMenu()
        .environmentObject(UserSessionManager())
}
