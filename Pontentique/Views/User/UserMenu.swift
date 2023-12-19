//
//  UserMenu.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/12/23.
//

import SwiftUI

struct UserMenu: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: UserMainPanel()) {}
            }
        }
    }
}

#Preview {
    UserMenu()
        .environmentObject(UserSessionManager())
}
