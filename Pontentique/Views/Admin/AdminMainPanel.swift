//
//  AdminMainPanel.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/01/24.
//

import SwiftUI

struct AdminMainPanel: View {
    enum SelectedView {
        case requestPanel, reportPanel, usersPanel
    }
    
    enum SelectedButton {
        case button1, button2, button3
    }
    
    @State private var selectedView: SelectedView = .reportPanel
    @State private var selectedButton: SelectedButton = .button1
    
    var body: some View {
        VStack {
            switch selectedView {
            case .requestPanel:
                AdminRequestMainPanel()
            case .reportPanel:
                AdminReportPanel()
            case .usersPanel:
                AdminUsersMainPainel()
            }
            Spacer()
            
            HStack {
                Spacer()
                
                //PONTO
                Button(action: {
                    selectedView = .reportPanel
                    selectedButton = .button1
                }) {
                    Image(systemName: selectedButton == .button1 ? "clock.fill" : "clock")
                        .foregroundStyle(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                
                Spacer()
                
                //TICKETS
                Button(action: {
                    selectedView = .requestPanel
                    selectedButton = .button2
                }) {
                    Image(systemName: selectedButton == .button2 ? "list.bullet.clipboard.fill" : "list.bullet.clipboard")
                        .foregroundStyle(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                
                Spacer()
                
                //USUÁRIOS
                Button(action: {
                    selectedView = .usersPanel
                    selectedButton = .button3
                }) {
                    Image(systemName: selectedButton == .button3 ? "person.2.fill" : "person.2")
                        .foregroundStyle(.blue)
                        .font(.system(size: 26))
                        .padding(.top, 20)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(ColorScheme.clockBtnBgColor)
        }
        .ignoresSafeArea(.keyboard)
    }
}
    

#Preview {
    AdminMainPanel()
}
