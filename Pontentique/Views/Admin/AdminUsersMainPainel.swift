//
//  AdminUsersMainPainel.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI
func colorFromString(_ colorName: String) -> Color {
    switch colorName {
    case "red":
        return Color.red
    case "green":
        return Color.green
    case "gray":
        return Color.gray
       
    default:
        return Color.blue
    }
}

struct AdminUsersMainPainel: View {
    @State private var users: [User] = []
    @State private var userStatus: [String: String] = [:]
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var selectedUser: User? = nil
    
    var body: some View {
        VStack {
            Text("Usuários")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 30)
            
            List(users) { user in
                Button(action: {
                       self.selectedUser = user
                   }) {
                       HStack {
                           Text(user.name)
                               .foregroundColor(.white)
                           Spacer()
                           Circle()
                               .fill(colorFromString(userStatus[String(user.id)] ?? "gray"))
                               .frame(width: 10, height: 10)
                           Image(systemName: "chevron.right")
                               .foregroundColor(.gray)
                       }
                   }
                   .buttonStyle(PlainButtonStyle())
                   .sheet(item: $selectedUser, onDismiss: fetchUsers) { user in
                           AdminEditUser(user: user, token: self.sessionManager.user?.token ?? "")
                       }
               }
               .listStyle(PlainListStyle())
        }
        .onAppear {
                fetchUsers()
            }
    }
    func fetchUsers() {
        if let token = sessionManager.user?.token {
            getAllUsers(token) { (users, error) in
                if let error = error {
                    print("Failed to fetch users: \(error)")
                } else if let users = users {
                    self.users = users
                    for user in users {
                        fetchUserStatus(userId: String(user.id), token: token) { status, error in
                            // handle status and error...
                        }
                    }
                }
            }
        }
    }
}



struct AdminUsersMainPainel_Previews: PreviewProvider {
    static var previews: some View {
        AdminUsersMainPainel()
    }
}
