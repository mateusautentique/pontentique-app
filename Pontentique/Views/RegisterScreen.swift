//
//  RegisterScreen.swift
//  Pontentique
//
//  Created by Mateus Zanella on 14/12/23.
//

import SwiftUI
import Combine
import UIKit

struct RegisterScreen: View {
    @State private var name: String = ""
    @State private var cpf: String = ""
    @State private var maskedCPF: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var password_confirmation: String = ""
    @State private var errorMessage: String?
    @State private var registerUser = false
    let placeHolderEmail = "jair@tuamaeaquelaursa.com" 
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: UserSessionManager
    
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
                ScrollView{
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
                            .gesture(
                                   TapGesture()
                                       .onEnded { _ in
                                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                       }
                               )
                        
                        Text("CPF")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        TextField("123.456.789-00", text: $maskedCPF)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .keyboardType(.numberPad)
                            .padding(.bottom, 10)
                            .onChange(of: maskedCPF) {oldValue, newValue in
                                cpf = newValue.filter { "0123456789".contains($0) }
                                            maskedCPF = applyMask(on: cpf)
                                    }
                            .gesture(
                                   TapGesture()
                                       .onEnded { _ in
                                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                       }
                               )
                        
                        Text("Email")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        TextField(placeHolderEmail, text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .padding(10)
                            .background(ColorScheme.fieldBgColor)
                            .foregroundColor(ColorScheme.textColor)
                            .cornerRadius(10)
                            .frame(width: 220)
                            .padding(.bottom, 10)
                            .gesture(
                                   TapGesture()
                                       .onEnded { _ in
                                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                       }
                               )
                        
                        Text("Senha")
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .padding(.leading, 5)
                        SecureField("umasenhabemsegura", text: $password)
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
                            userRegister(cpf: cpf, name: name, email: email, password: password, password_confirmation: password_confirmation) { (token, error) in
                                if let token = token {
                                    errorMessage = nil
                                    getLoggedUser(token){ (user, error) in
                                        if let user = user {
                                            DispatchQueue.main.async {
                                                self.sessionManager.session = .loggedIn(user)
                                            }
                                        } else if let error = error {
                                            self.errorMessage = error.localizedDescription
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                                errorMessage = nil
                                            }
                                        }
                                    }
                                } else if let error = error {
                                    self.errorMessage = error.localizedDescription
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                        errorMessage = nil
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Registrar-se")
                            .padding(12)
                            .background(ColorScheme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    if let errorMessage = errorMessage {
                        Text("ⓘ \(errorMessage)")
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                }
                
                .padding()
                .background(ColorScheme.appBackgroudColor)
                Spacer()
            }
            
            .padding()
            .background(ColorScheme.appBackgroudColor)
        }
    }
    
    func applyMask(on value: String) -> String {
        let cleanCPF = value.filter { "0123456789".contains($0) }
        var maskedCPF = ""
        
        for (index, char) in cleanCPF.enumerated() {
            if index == 11 { break }
            if index == 3 || index == 6 {
                maskedCPF += "."
            } else if index == 9 {
                maskedCPF += "-"
            }
            maskedCPF += String(char)
        }
        return maskedCPF
    }
}


#Preview {
    RegisterScreen()
}
