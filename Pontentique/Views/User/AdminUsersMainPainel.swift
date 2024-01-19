//
//  AdminUsersMainPainel.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()
    let name: String
}

struct AdminUsersMainPainel: View {
    
    let users: [User] = [
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)"),
        User(name: "Username(0-0)")
     
        
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

        VStack{
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // Ação do botão 1
                }) {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                Spacer()
                Button(action: {
                    // Ação do botão 2
                }) {
                    Image(systemName: "list.bullet.clipboard")
                        .foregroundColor(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                Spacer()
                Button(action: {
                    // Ação do botão 3
                }) {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(ColorScheme.clockBtnBgColor)
    }
}
#Preview {
    AdminUsersMainPainel()
}
