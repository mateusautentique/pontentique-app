//
//  AdminEditUser.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI

enum ActiveAlert { case  deleteConfirmation, success}

enum ActiveAlertSave { case first, second }


struct AdminEditUser: View {
    //MARK: - Call other files
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: UserSessionManager
    @State private var ActiveAlertSave: ActiveAlertSave = .first
    @State private var errorMessage = ""
    //MARK: - User info
    @State var user: User
    @State var token: String?
    @State private var showAlert = false
    @State private var successMessage = ""
    //MARK: - Deleting User
    @State private var showingAlert = false
    @State private var activeAlert: ActiveAlert = .deleteConfirmation
    
    
    func saveChanges(completion: @escaping (String?, Error?) -> Void) {
        if let token = self.token {
            
            let userId = user.id
            let name = user.name
            let email = user.email
            let cpf = user.cpf
            editUser(userId: userId, name: name, email: email, cpf: cpf, token: token) { (updatedUser, error) in
                if let error = error as? NSError, error.code == 401 {
                } else if error != nil {
                } else if let updatedUser = updatedUser {
                    self.user = updatedUser
                    print("User updated successfully")
                }
            }
        }
        var saveSuccessful = true
                
        if saveSuccessful {
            completion("As alterações foram salvas com sucesso", nil)
        } else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Erro ao tentar salvar!"]))
        }
    }
    
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
                        TextField("Nome", text: $user.name)
                            .padding(.leading,25)
                    }
                    
                    HStack(alignment: .center) {
                        Text("CPF")
                            .frame(width: 80, alignment: .leading)
                        TextField("CPF", text: $user.cpf)
                            .padding(.leading,25)
                        
                            .onChange(of: user.cpf) {oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count > 11 {
                                    user.cpf = String(filtered.prefix(11))
                                } else {
                                    user.cpf = filtered
                                }
                            }
                    }
                    
                    
                    HStack(alignment: .center) {
                        Text("Email")
                            .frame(width: 80, alignment: .leading)
                        TextField("Email", text: $user.email)
                            .padding(.leading,25)
                        
                    }
                }
                
                Button(action: {
                    self.activeAlert = .deleteConfirmation
                    self.showingAlert = true
                    
                }) {
                    Text("Excluir usuário")
                        .foregroundColor(.red)
                }
                .padding(.bottom,300)
                .alert(isPresented: $showingAlert) {
                    switch activeAlert {
                    case .deleteConfirmation:
                        return Alert(title: Text("Tem certeza?"),
                                     message: Text("Você quer mesmo deletar \(user.name)?"),
                                     primaryButton: .destructive(Text("Sim")) {
                            deleteUser(userId: user.id, token: self.sessionManager.user?.token ?? "") { (success, error) in
                                if let error = error {
                                    print("Error deleting user: \(error)")
                                } else if success {
                                    self.activeAlert = .success
                                    self.showingAlert = true
                                } else {
                                    print("Failed to delete user")
                                }
                            }
                        },
                                     secondaryButton: .cancel())
                    case .success:
                        return Alert(title: Text("Boa deu certo!"),
                                     message: Text("\(user.name) foi deletado com sucesso."),
                                     dismissButton: .default(Text("=]")) {
                            self.showingAlert = false
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
                Text("\(errorMessage)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .foregroundColor(.red)

            }
            
            
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Usuários")
                },
                trailing: Button(action: {
                    self.ActiveAlertSave = .first
                    self.showAlert = true
                }) {
                    Text("Salvar")
                }.alert(isPresented: $showAlert) {
                    switch ActiveAlertSave.self {
                    case .first:
                        return Alert(title: Text("Confirmar"),
                                     message: Text("Você quer mesmo salvar as alterações?"),
                                     primaryButton: .default(Text("Sim"), action: {
                        
                            saveChanges { (success, error) in
                                if let error = error {
                                    print("Error saving changes: \(error)")
                                    self.errorMessage = "ⓘErro ao salvar: \(error.localizedDescription)"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.errorMessage = ""
                                    }
                                } else if success != nil {
                                    DispatchQueue.main.async {
                                        self.ActiveAlertSave = .second
                                        self.showAlert = true
                                    }
                                } else {
                                    print("Failed to save changes")
                                    self.errorMessage = "ⓘFalha ao salvar as mudanças"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.errorMessage = ""
                                    }
                                }
                            }
                        }),
                                     secondaryButton: .cancel())
                    case .second:
                        return Alert(title: Text("Boa deu certo!"),
                                     message: Text(successMessage),
                                     dismissButton: .default(Text("=]")) {
                            self.showAlert = false
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
                
            )
            .listStyle(PlainListStyle())
        }
    }
}


#Preview {
    AdminEditUser(user: User(name: "Existing User", cpf: "123456789", email: "existing.user@example.com")
                  , token: "")
}

