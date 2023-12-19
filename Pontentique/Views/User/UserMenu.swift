//
//  UserMenu.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/12/23.
//

import SwiftUI

struct UserMenu: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: UserMainPanel()){}
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
        }
    }
}

#Preview {
    UserMenu()
}
