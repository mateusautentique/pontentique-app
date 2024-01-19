//
//  AdminEditUser.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI

struct AdminEditUser: View {
    @State private var name: String = "Username(0-0)"
    @State private var cpf: String = "123.456.789-99"
    @State private var email: String = "user@email.com"
    
    var body: some View {
        NavigationView {
            Group{
                Text("Editar usuário")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .padding(.trailing, 200)
                    .background(ColorScheme.fieldBgColor)
                    .font(.system(size: 28))
                    .padding(.bottom, 10)
                List {
                    HStack(alignment: .center) {
                        Text("Nome")
                            .frame(width: 80, alignment: .leading)
                        TextField("Nome", text: $name)
                            .padding(.leading,25)
                    }
                    
                    HStack(alignment: .center) {
                        Text("CPF")
                            .frame(width: 80, alignment: .leading)
                        TextField("CPF", text: $cpf)
                            .padding(.leading,25)
                    }
                    
                    
                    HStack(alignment: .center) {
                        Text("Email")
                            .frame(width: 80, alignment: .leading)
                        TextField("Email", text: $email)
                            .padding(.leading,25)
                    }
                }
                
                Button(action: {
                    // Handle delete user action
                }) {
                    Text("Excluir usuário")
                        .foregroundColor(.red)
                }
                .padding(.bottom,400)
            }
            
            .navigationBarItems(
                leading: Button(action: {
                    // Handle back action
                }) {
                    Image(systemName: "chevron.left")
                    Text("Usuários")
                },
                trailing: Button(action: {
                    // Handle save action
                }) {
                    Text("Salvar")
                }
            )
        }
        .listStyle(PlainListStyle())
    }
}
#Preview {
    AdminEditUser()
}
