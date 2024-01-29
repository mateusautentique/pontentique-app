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
    var token: String?
    @State private var showAlert = false
    @State private var successMessage = ""
    @State private var selectedRole: String = ""
    @State private var workJourneyHours: Int
    let roles = ["user", "admin"]
    let hours = Array(4...12)
    
    
    //MARK: - Deleting User
    @State private var showingAlert = false
    @State private var activeAlert: ActiveAlert = .deleteConfirmation
    
    init(user: User, token: String?) {
        _user = State(initialValue: user)
        _selectedRole = State(initialValue: user.role)
        _workJourneyHours = State(initialValue: user.workJourneyHours)
        self.token = token
    }
    
    func saveChanges(completion: @escaping (String?, Error?) -> Void) {
        if let token = self.token {
            let userId = user.id
            let name = user.name
            let email = user.email
            let cpf = user.cpf
            let role = selectedRole // Use selectedRole directly
            let workJourneyHours = Int(self.workJourneyHours)
            editUser(userId: userId, name: name, email: email, cpf: cpf, role: role, workJourneyHours: workJourneyHours, token: token) { (updatedUser, error) in
                if let error = error as? NSError, error.code == 401 {
                } else if error != nil {
                } else if let updatedUser = updatedUser {
                    self.user = updatedUser
                    print("User updated successfully")
                }
            }
        }
        completion("As alterações foram salvas com sucesso", nil)
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
                    HStack(alignment: .center){
                                          Text("Cargo")
                                              .frame(width: 80, alignment: .leading)
                                          Picker(selection: $selectedRole, label: EmptyView()) {
                                              ForEach(roles, id: \.self) {
                                                  Text($0.capitalized)
                                              }
                                          }    
                            .pickerStyle(MenuPickerStyle())
                            .labelsHidden()
                            .padding(.leading,14)

                    }
                    HStack(alignment: .center){
                        Text("Jornada")
                            .frame(width: 80, alignment: .leading)
                            .keyboardType(.numberPad)
                        Picker(selection: $workJourneyHours, label: Text("\(workJourneyHours)")) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .padding(.leading,25)
                        .labelsHidden()
                        .pickerStyle(DefaultPickerStyle())
                    }
                }
                Button(action: {
                    self.activeAlert = .deleteConfirmation
                    self.showingAlert = true
                    
                }) {
                    Text("Excluir usuário")
                        .foregroundColor(.red)
                }
                .padding(.top, 25)
                .padding(.bottom,150)
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
<<<<<<< HEAD
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
                                    self.errorMessage = "ⓘ Falha ao salvar as mudanças"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.errorMessage = ""
                                    }
                                }
                            }
                        }), secondaryButton: .cancel())
                    case .second:
                        return Alert(title: Text("Boa deu certo!"),
                                     message: Text(successMessage),
                                     dismissButton: .default(Text("=]")) {
                            self.showAlert = false
                            self.presentationMode.wrappedValue.dismiss()
                        })
=======
                }
                    .alert(isPresented: $showAlert) {
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
>>>>>>> gui
                    }
                
            )
            .listStyle(PlainListStyle())
        }
    }
}


#Preview {
    AdminEditUser(user: User(name: "Existing User", cpf: "123456789", email: "existing.user@example.com"),token: ""
    )
}

