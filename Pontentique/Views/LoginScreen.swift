//
//  LoginScreen.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/11/23.
//

import SwiftUI
import Combine

struct LoginScreen: View {
    @State private var textFieldLogin: String = ""
    @State var textFieldPassword: String = ""
    @State private var errorMessage: String?
    @State private var cpf: String = ""
    @State private var maskedCPF: String = ""
    @State private var showRegisterScreen = false
    @State private var showLoadingScreen = false
    @EnvironmentObject var sessionManager: UserSessionManager
    
    var body: some View {
        ZStack{
            NavigationStack {
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer()
                        VStack {
                            Text("Seja bem vindo ao Pontentique!")
                                .font(.headline)
                                .padding(.bottom, 10)
                            Text("Faça login ou registre-se")
                                .font(.subheadline)
                        }
                        .foregroundColor(ColorScheme.textColor)
                        .padding(.bottom, 40)
                        
                        VStack(alignment: .leading) {
                            Text("CPF")
                                .font(.subheadline)
                                .padding(.bottom, 0)
                                .padding(.leading, 5)
                            TextField("CPF", text: $maskedCPF)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(10)
                                .background(ColorScheme.fieldBgColor)
                                .keyboardType(.numberPad)
                                .foregroundColor(ColorScheme.textColor)
                                .cornerRadius(10)
                                .frame(width: 220)
                                .padding(.bottom, 10)
                                .keyboardType(.numberPad)
                                .onChange(of: maskedCPF) {oldValue, newValue in
                                    textFieldLogin = newValue.filter { "0123456789".contains($0) }
                                    maskedCPF = applyMask(on: textFieldLogin)
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
                            
                            Button(action: {
                                Task {
                                    DispatchQueue.main.async {
                                        self.errorMessage = nil
                                        self.showLoadingScreen = true
                                    }
                                    
                                    userLogin(textFieldLogin, textFieldPassword) { (token, error) in
                                        if let token = token {
                                            UserDefaults.standard.set(token, forKey: "userToken")
                                            
                                            getLoggedUser(token){ (user, error) in
                                                if let user = user {
                                                    DispatchQueue.main.async {
                                                        self.sessionManager.session = .loggedIn(user)
                                                    }
                                                } else if let error = error {
                                                    self.errorMessage = error.localizedDescription
                                                    self.showLoadingScreen = false
                                                }
                                            }
                                            
                                            Timer.scheduledTimer(withTimeInterval: 3600, repeats: false) { _ in
                                                UserDefaults.standard.removeObject(forKey: "userToken")
                                            }
                                        } else if let error = error {
                                            self.errorMessage = error.localizedDescription
                                        }
                                    }
                                }
                            }) {
                                Text("Entrar")
                                    .padding(12)
                                    .frame(maxWidth: .infinity)
                                    .background(ColorScheme.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .frame(width: 220)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top, 20)
                        }
                        .padding(.top, 15)
                        
                        Button(action: {
                            showRegisterScreen = true
                        }) {
                            Text("Registre-se")
                                .padding(12)
                                .foregroundColor(ColorScheme.primaryColor)
                                .fontWeight(.bold)
                                .underline()
                                .cornerRadius(10)
                                .fullScreenCover(isPresented: $showRegisterScreen) {
                                    RegisterScreen()
                                        .foregroundColor(ColorScheme.textColor)
                                        .multilineTextAlignment(.leading)
                                        .transition(.move(edge: .trailing))
                                        .animation(.default, value: showRegisterScreen)
                                }
                                .padding(.top, 5)
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        
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
            .blur(radius: showLoadingScreen ? 3 : 0)
            if showLoadingScreen {
                LoadingLoginScreenView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            checkUserSession()
        }
    }
    
    func checkUserSession() {
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            getLoggedUser(token){ (user, error) in
                if let user = user {
                    DispatchQueue.main.async {
                        self.sessionManager.session = .loggedIn(user)
                    }
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
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

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(UserSessionManager())
    }
}
