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
    @Binding var isAuthenticated: Bool
    @State private var errorMessage: String?
    
    @State private var showRegisterScreen = false
    
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
                                            // Handle token
                                            print("Token: \(token)")
                                            // Navigate to the next screen or save the token for future API requests
                                        } else if let error = error {
                                            self.errorMessage = error.localizedDescription
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
                            
                            NavigationLink(destination: RegisterScreen()) {
                                Text("Registrar")
                                    .padding(12)
                                    .frame(width: 100)
                                    .background(ColorScheme.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
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
        LoginScreen(textFieldLogin: "", isAuthenticated: .constant(false))
    }
}
