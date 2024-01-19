//
//  AdminUsersMainPainel.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI

struct TestUser: Identifiable {
    let id = UUID()
    let name: String
}

struct AdminUsersMainPainel: View {
    
    let users: [TestUser] = [
        TestUser(name: "Username(0-0)"),
        TestUser(name: "Username(0-0)"),
        TestUser(name: "Username(0-0)"),
        TestUser(name: "Username(0-0)")
    ]
    var body: some View {
        VStack {
            Text("Usuários")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 30)
            
            List(users) { user in
                Button(action: {
                    //Ação do botão do user
                }) {
                    HStack {
                        Text(user.name)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())
        }
    }
}
#Preview {
    AdminUsersMainPainel()
}
