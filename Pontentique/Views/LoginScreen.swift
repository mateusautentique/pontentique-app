//
//  LoginScreen.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI
import Combine

struct LoginScreen: View {
    @State var textFieldLogin: String = ""
    @State var textFieldPassword: String = ""
    @State private var errorMessage: String?
    
    @State private var showRegisterScreen = false
    @State private var isLoggedIn = false
    @EnvironmentObject var sessionManager: UserSessionManager
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    VStack {
                        Text("Seja bem vindo ao Pontentique™!")
                            .font(.headline)
                            .padding(.bottom, 10)
                        Text("Faça login ou registre-se")
                            .font(.subheadline)
                    }
                    .foregroundColor(ColorScheme.textColor)
                    .padding(.bottom, 40)
                    
                    //Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("CPF")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        TextField("CPF", text: $textFieldLogin)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .padding(.bottom, 10)
                            .onReceive(Just(textFieldLogin)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.textFieldLogin = filtered
                                }
                                if textFieldLogin.count > 11 {
                                    textFieldLogin = String(textFieldLogin.prefix(11))
                                }
                            }
                        Text("Senha")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        SecureField("Senha", text: $textFieldPassword)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .padding(.bottom, 10)
                        
                        HStack {
                            Button(action: {
                                Task {
                                    userLogin(textFieldLogin, textFieldPassword) { (token, error) in
                                        if let token = token {
                                            self.errorMessage = nil
                                            getLoggedUser(token){ (user, error) in
                                                if let user = user {
                                                    self.sessionManager.session = .loggedIn(user)
                                                    DispatchQueue.main.async {
                                                        isLoggedIn = true
                                                    }
                                                } else if let error = error {
                                                    self.errorMessage = error.localizedDescription
                                                }
                                            }
                                        } else if let error = error {
                                            self.errorMessage = error.localizedDescription
                                        } else {
                                            self.errorMessage = "Não foi possível conectar-se ao servidor"
                                        }
                                    }
                                }
                            }) {
                                Text("Entrar")
                                    .padding(12)
                                    .frame(width: 100)
                                    .background(ColorScheme.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.trailing, 10)
                            .navigationDestination(isPresented: $isLoggedIn) {
                                UserMainPanel()
                                    .navigationBarBackButtonHidden(true)
                            }
                            
                            Button(action: {
                                showRegisterScreen = true
                            }) {
                                Text("Registrar")
                                    .padding(12)
                                    .frame(width: 100)
                                    .background(ColorScheme.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .fullScreenCover(isPresented: $showRegisterScreen) {
                                        RegisterScreen()
                                            .foregroundColor(ColorScheme.textColor)
                                            .multilineTextAlignment(.leading)
                                            .transition(.move(edge: .trailing))
                                            .animation(.default, value: showRegisterScreen)
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 15)
                    }
                    .padding()
                    
                    HStack {
                        Spacer()
                        if let errorMessage = errorMessage {
                            Text("ⓘ \(errorMessage)")
                                .foregroundColor(.red)
                                .padding(.top, 10)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding()
                .background(ColorScheme.appBackgroudColor)
                
                Spacer()
            }
            .padding()
            .background(ColorScheme.appBackgroudColor)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(UserSessionManager())
    }
}
