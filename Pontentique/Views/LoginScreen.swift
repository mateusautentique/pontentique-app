//
//  LoginScreen.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI

struct LoginScreen: View {
    @State var textFieldLogin: String = ""
    @State var textFieldPassword: String = ""
    @Binding var isAuthenticated: Bool
    
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
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
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
                        
                        HStack {
                            Button(action: {
                                Task {
                                    print("login")
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
                            
                            Button(action: {
                                print("Register")
                            }) {
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
