//
//  RegisterScreen.swift
//  Pontentique
//
//  Created by Mateus Zanella on 14/12/23.
//

import SwiftUI
import Combine

struct RegisterScreen: View {
    @State private var name: String = ""
    @State private var cpf: String = ""
    @State private var email: String = ""
    @State private var passoword: String = ""
    @State private var password_confirmation: String = ""
    let placeHolderEmail = "jair@tuamaeaquelaursa.com"
    
    @State private var registerUser = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: LoginScreen()){}
                .navigationBarTitle("Retornar para o Login", displayMode: .inline)
                .font(.subheadline)
                .foregroundColor(ColorScheme.textColor)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(ColorScheme.textColor)
                })
            
            HStack {
                Spacer()
                VStack {
                    Text("Insira as suas informações:")
                        .font(.subheadline)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Nome")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        TextField("Jair Teste da Silva", text: $name)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .padding(.bottom, 10)
                        
                        Text("CPF")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        TextField("12345678900", text: $cpf)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .padding(.bottom, 10)
                            .onReceive(Just(cpf)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.cpf = filtered
                                }
                                if cpf.count > 11 {
                                    cpf = String(cpf.prefix(11))
                                }
                            }
                        
                        Text("Email")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        TextField(placeHolderEmail, text: $email)
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
                        SecureField("umasenhabemsegura", text: $passoword)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .padding(.bottom, 10)
                            .textContentType(.oneTimeCode)
                        
                        Text("Confirmar senha")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        SecureField("umasenhabemsegura", text: $password_confirmation)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .padding(.bottom, 10)
                            .textContentType(.oneTimeCode)
                    }
                    .padding()
                    
                    Button(action: {
                        Task {
                            // registerUser()
                            registerUser = true
                        }
                    }) {
                        Text("Registrar-se")
                            .padding(12)
                            .background(ColorScheme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .fullScreenCover(isPresented: $registerUser) {
                                //PLACEHOLDER OBV
                                LoginScreen()
                                    .foregroundColor(ColorScheme.textColor)
                                    .multilineTextAlignment(.leading)
                                //PLACEHOLDER OBV
                            }
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


#Preview {
    RegisterScreen()
}
