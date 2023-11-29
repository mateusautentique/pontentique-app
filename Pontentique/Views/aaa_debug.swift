//
//  debug.swift
//  Pontentique
//
//  Created by Mateus Zanella on 28/11/23.
//

import SwiftUI

struct debug: View {
    var body: some View {
        Button (action: {
            Task {
                do {
                    let sessionisValid = try await validateSession("mlZLTPetBBDTRmwkybcCffnL")
                    print(sessionisValid)
                } catch {
                    print("An error occurred: \(error)")
                }
                try await userLogout("mlZLTPetBBDTRmwkybcCffnL")
                do {
                    let sessionisValid = try await validateSession("mlZLTPetBBDTRmwkybcCffnL")
                    print(sessionisValid)
                } catch {
                    print("An error occurred: \(error)")
                }
            }
        }) {
            Text("Debug")
        }
    }
}

#Preview {
    debug()
}
