import SwiftUI


enum ActiveAlert { case deleteConfirmation, deleteSuccess, saveConfirmation, saveSuccess }

struct AdminEditUser: View {
    //MARK: - VIEW VARIABLES
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - SESSION INFO
    @EnvironmentObject var sessionManager: UserSessionManager
    
    //MARK: - ALERT INFO
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .saveConfirmation
    @State private var errorMessage = ""
    @State private var successMessage = ""
    
    //MARK: - User info
    var token: String?
    @State var user: User
    @State private var selectedRole: String = ""
    @State private var workJourneyHours: Int
    let roles = ["user", "admin"]
    let hours = Array(4...12)
    
    init(user: User, token: String?) {
        _user = State(initialValue: user)
        _selectedRole = State(initialValue: user.role)
        _workJourneyHours = State(initialValue: user.workJourneyHours)
        self.token = token
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Editar usuário")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .padding(.trailing, 200)
                    .background(ColorScheme.fieldBgColor)
                    .font(.system(size: 28))
                    .padding(.bottom, 10)
                
                VStack{
                    HStack{
                        Text("Nome")
                            .frame(width: 80, alignment: .leading)
                            .padding(.leading, 12)
                        TextField("Nome", text: $user.name)
                            .padding(.leading,25)
                    }
                    .padding(.bottom,3)
                    .padding(.top,3)
                    Divider()
                    HStack(){
                        Text("CPF")
                            .frame(width: 80, alignment: .leading)
                            .padding(.leading, 12)
                        TextField("CPF", text: $user.cpf)
                            .padding(.leading,25)
                            .keyboardType(.numberPad)
                            .onChange(of: user.cpf) {oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count > 11 {
                                    user.cpf = String(filtered.prefix(11))
                                } else {
                                    user.cpf = filtered
                                }
                            }
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }
                    .padding(.bottom,3)
                    .padding(.top,3)
                    Divider()
                    HStack(alignment: .center) {
                        Text("Email")
                            .frame(width: 80, alignment: .leading)
                            .padding(.leading, 12)
                        TextField("Email", text: $user.email)
                            .padding(.leading,25)
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }
                    .padding(.bottom,3)
                    .padding(.top,3)
                    Divider()
                    HStack{
                        Text("Cargo")
                            .frame(width: 80, alignment: .leading)
                            .padding(.leading, 12)
                        Picker(selection: $selectedRole, label: EmptyView()) {
                            ForEach(roles, id: \.self) {
                                Text($0.capitalized)
                            }
                        }
                        .padding(.leading,14)
                        Spacer()
                            .pickerStyle(MenuPickerStyle())
                            .labelsHidden()
                        
                    }
                    Divider()
                    HStack{
                        Text("Jornada")
                            .frame(width: 80, alignment: .leading)
                            .padding(.leading, 12)
                            .keyboardType(.numberPad)
                        Picker(selection: $workJourneyHours, label: Text("\(workJourneyHours)")) {
                            ForEach(hours, id: \.self) { hour in
                                Text("\(hour)")
                            }
                        }
                        .padding(.leading,15)
                        .pickerStyle(DefaultPickerStyle())
                        .labelsHidden()
                        Spacer()
                    }
                    .padding(.bottom, 50)
                    
                    Button(action: {
                        self.activeAlert = .deleteConfirmation
                        self.showAlert = true
                        
                    }) {
                        Text("Excluir usuário")
                            .foregroundColor(.red)
                    }
                    
                    Text("\(errorMessage)")
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .foregroundColor(.red)
                    Spacer()
                }
            }
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Usuários")
                },
                trailing: Button(action: {
                    self.activeAlert = .saveConfirmation
                    self.showAlert = true
                }) {
                    Text("Salvar")
                }
            )
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .deleteConfirmation:
                    return Alert(title: Text("Tem certeza?"),
                                 message: Text("Você quer mesmo deletar \(user.name)?"),
                                 primaryButton: .destructive(Text("Sim")) {
                        deleteUser(userId: user.id, token: self.sessionManager.user?.token ?? "") { (success, error) in
                            if let error = error {
                                print("Error deleting user: \(error)")
                            } else if success {
                                self.activeAlert = .deleteSuccess
                                self.showAlert = true
                            }
                        }
                    }, secondaryButton: .cancel())
                case .deleteSuccess:
                    return Alert(title: Text("Boa deu certo!"),
                                 message: Text("\(user.name) foi deletado com sucesso."),
                                 dismissButton: .default(Text("=]")) {
                        self.showAlert = false
                        self.presentationMode.wrappedValue.dismiss()
                    })
                case .saveConfirmation:
                    return Alert(title: Text("Confirmar"),
                                 message: Text("Você quer mesmo salvar as alterações?"),
                                 primaryButton: .default(Text("Sim"), action: {
                        saveChanges { (success, error) in
                            if let error = error {
                                print("Error saving changes: \(error)")
                                self.errorMessage = "ⓘ Erro ao salvar: \(error.localizedDescription)"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.errorMessage = ""
                                }
                            } else if success != nil {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.activeAlert = .saveSuccess
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
                case .saveSuccess:
                    return Alert(title: Text("Boa deu certo!"),
                                 message: Text(successMessage),
                                 dismissButton: .default(Text("=]")) {
                        self.showAlert = false
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
            }
        }
    }
    
    func saveChanges(completion: @escaping (String?, Error?) -> Void) {
        if let token = self.token {
            let userId = user.id
            let name = user.name
            let email = user.email
            let cpf = user.cpf
            let role = selectedRole
            let workJourneyHours = Int(self.workJourneyHours)
            editUser(userId: userId, name: name, email: email, cpf: cpf, role: role, workJourneyHours: workJourneyHours, token: token) {
                (updatedUser, error) in
                DispatchQueue.main.async {
                    if let error = error as? NSError, error.code == 401 {
                        errorMessage = error.localizedDescription
                    } else if let updatedUser = updatedUser {
                        self.user = updatedUser
                    }
                }
            }
        }
        completion("As alterações foram salvas com sucesso", nil)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    AdminEditUser(user: User(name: "Existing User", cpf: "123456789", email: "existing.user@example.com"),token: ""
    )
}
