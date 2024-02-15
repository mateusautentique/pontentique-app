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
    @State private var showAlert = false
    @State private var cpf: String = ""
    @State private var maskedCPF: String = ""
    @State private var pis: String = ""
    @State private var formattedpis: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var password_confirmation: String = ""
    @State private var errorMessage: String?
    @State private var registerUser = false
    @State private var showLoadingScreen = false
    @State private var scrollToError: Bool = false
    @State private var fields: [String: Bool] = [
        "name": false,
        "cpf": false,
        "email": false,
        "password": false,
        "password_confirmation": false
    ]
    
    let statusCodesToFields: [Int: String] = [
        490: "name",
        491: "cpf",
        492: "email",
        493: "password",
        494: "password_confirmation",
        495: "pis"
    ]
    
    let placeHolderEmail = "user@example.com"
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: UserSessionManager
    
    var body: some View {
        ZStack{
            NavigationStack {
                NavigationLink(destination: LoginScreen()){}
                    .navigationBarTitle("Retornar para o Login", displayMode: .inline)
                    .font(.subheadline)
                    .foregroundStyle(ColorScheme.textColor)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(ColorScheme.textColor)
                    })
                
                HStack {
                    Spacer()
                    ScrollView{
                        ScrollViewReader { scrollView in
                            VStack{
                                Text("Insira as suas informações:")
                                    .font(.subheadline)
                                    .padding(.bottom, 10)
                                
                                VStack(alignment: .leading) {
                                    Text("Nome")
                                        .font(.subheadline)
                                        .padding(.bottom, 0)
                                        .padding(.leading, 5)
                                    TextField("Nome", text: $name)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(10)
                                        .background(ColorScheme.fieldBgColor)
                                        .foregroundStyle(ColorScheme.textColor)
                                        .cornerRadius(10)
                                        .frame(width: 220)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(fields["name"] == true ? Color.red : Color.clear, lineWidth: 1)
                                        )
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
                                    TextField("000.000.000-00", text: $maskedCPF)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(10)
                                        .background(ColorScheme.fieldBgColor)
                                        .foregroundStyle(ColorScheme.textColor)
                                        .cornerRadius(10)
                                        .frame(width: 220)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(fields["cpf"] == true ? Color.red : Color.clear, lineWidth: 1)
                                        )
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
                                    
                                    Text("PIS/PASEP")
                                        .font(.subheadline)
                                        .padding(.bottom, 0)
                                        .padding(.leading, 5)
                                    TextField("000.00000.00-0", text: $formattedpis)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(10)
                                        .background(ColorScheme.fieldBgColor)
                                        .foregroundStyle(ColorScheme.textColor)
                                        .cornerRadius(10)
                                        .frame(width: 220)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(fields["pis"] == true ? Color.red : Color.clear, lineWidth: 1)
                                        )
                                        .keyboardType(.numberPad)
                                        .padding(.bottom, 10)
                                        .gesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                }
                                        )
                                        .onChange(of: formattedpis) {oldValue, newValue in
                                            pis = newValue.filter { "0123456789".contains($0) }
                                            formattedpis = formatPIS(pis)
                                        }
                                    
                                    Text("Email")
                                        .font(.subheadline)
                                        .padding(.bottom, 0)
                                        .padding(.leading, 5)
                                    TextField(placeHolderEmail, text: $email)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.emailAddress)
                                        .padding(10)
                                        .background(ColorScheme.fieldBgColor)
                                        .foregroundStyle(ColorScheme.textColor)
                                        .cornerRadius(10)
                                        .frame(width: 220)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(fields["email"] == true ? Color.red : Color.clear, lineWidth: 1)
                                        )
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
                                    SecureField("Senha", text: $password)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(10)
                                        .background(ColorScheme.fieldBgColor)
                                        .foregroundStyle(ColorScheme.textColor)
                                        .cornerRadius(10)
                                        .frame(width: 220)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(fields["password"] == true ? Color.red : Color.clear, lineWidth: 1)
                                        )
                                        .padding(.bottom, 10)
                                        .textContentType(.oneTimeCode)
                                    
                                    Text("Confirmar senha")
                                        .font(.subheadline)
                                        .padding(.bottom, 0)
                                        .padding(.leading, 5)
                                    SecureField("Confirme sua senha", text: $password_confirmation)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(10)
                                        .background(ColorScheme.fieldBgColor)
                                        .foregroundStyle(ColorScheme.textColor)
                                        .cornerRadius(10)
                                        .frame(width: 220)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(fields["password_confirmation"] == true ? Color.red : Color.clear, lineWidth: 1)
                                        )
                                        .padding(.bottom, 10)
                                        .textContentType(.oneTimeCode)
                                }
                                .padding()
                                
                                Button(action: {
                                    Task {
                                        self.errorMessage = nil
                                        userRegister(cpf: cpf, pis: pis, name: name, email: email,
                                                     password: password, password_confirmation: password_confirmation) { (reponse, statusCode, error) in
                                            fields = [
                                                "name": false,
                                                "cpf": false,
                                                "email": false,
                                                "password": false,
                                                "password_confirmation": false,
                                                "pis": false
                                            ]
                                            
                                            if statusCode == 200 {
                                                DispatchQueue.main.async {
                                                    self.errorMessage = nil
                                                }
                                                if reponse != nil {
                                                    errorMessage = nil
                                                    self.showAlert = true
                                                } else if let error = error {
                                                    self.errorMessage = error.localizedDescription
                                                    self.showLoadingScreen = false
                                                }
                                            } else {
                                                errorMessage = reponse
                                                if let fieldName = statusCodesToFields[statusCode ?? 0] {
                                                    fields[fieldName] = true
                                                }
                                            }
                                        }
                                    }
                                }) {
                                    Text("Registrar")
                                        .padding(12)
                                        .background(ColorScheme.primaryColor)
                                        .foregroundStyle(.white)
                                        .cornerRadius(10)
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Boa deu certo!"), message: Text("Você registrou: \(name)"), dismissButton: .default(Text("OK")) {
                                        self.presentationMode.wrappedValue.dismiss()
                                    })
                                }
                                Spacer()
                                
                                if let errorMessage = errorMessage {
                                    Text("ⓘ \(errorMessage)")
                                        .foregroundStyle(.red)
                                        .padding(.top, 10)
                                        .id("ErrorMessage")
                                }
                            }
                            
                            .onChange(of: errorMessage) {oldValue, newValue in
                                if newValue != nil {
                                    withAnimation {
                                        scrollToError = true
                                    }
                                }
                            }
                            .onChange(of: scrollToError) {oldValue, newValue in
                                if newValue {
                                    scrollView.scrollTo("ErrorMessage", anchor: .bottom)
                                    scrollToError = false
                                }
                            }
                        }
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
    
    func formatPIS(_ value: String) -> String {
        let cleanPIS = value.filter { "0123456789".contains($0) }
        var formattedPIS = ""
        
        for (index, char) in cleanPIS.enumerated() {
            if index == 11 { break }
            if index == 3 || index == 8 {
                formattedPIS += "."
            } else if index == 10 {
                formattedPIS += "-"
            }
            formattedPIS += String(char)
        }
        return formattedPIS
    }
}


#Preview {
    RegisterScreen()
}
