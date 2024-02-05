//
//  AdminUsersMainPainel.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI

struct AdminUsersMainPainel: View {
    //MARK: - SESSION INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - USER INFO
    @State private var users: [User] = []
    @State private var userStatus: [String: String] = [:]
    @State private var selectedUser: User? = nil
    
    //MARK: - TIMER
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    //MARK: - ERROR
    @State private var errorMessage: String?
    
    //MARK: - VIEW
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
                            .foregroundStyle(ColorScheme.textColor)
                        Spacer()
                        Circle()
                            .fill(colorFromString(userStatus[String(user.id)] ?? "gray"))
                            .frame(width: 10, height: 10)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(ColorScheme.tableTextColor)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(selectedUser != nil)
                .sheet(item: $selectedUser, onDismiss: fetchUsers) { user in
                    AdminEditUser(user: user, token: self.sessionManager.user?.token ?? "")
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            fetchUsers()
        }
        .onReceive(timer) { _ in
            fetchUsers()
        }
    }
    
    func fetchUsers() {
        if let token = sessionManager.user?.token {
            getAllUsers(token) { (users, error) in
                if let error = error {
                    print("Failed to fetch users: \(error)")
                } else if let users = users {
                    DispatchQueue.main.async {
                        self.users = users
                        for user in users {
                            fetchUserStatus(userId: user.id, token: token) { status, error in
                                if let status = status {
                                    print(status)
                                    self.userStatus[String(user.id)] = status.lowercased()
                                }
                                if let error = error { print(error.localizedDescription) }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - AUX
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
}


//
//struct AdminUsersMainPainel_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminUsersMainPainel()
//    }
//}
