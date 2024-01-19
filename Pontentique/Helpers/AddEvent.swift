//
//  AddEvent.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 18/01/24.
//

import SwiftUI

struct AddEvent: View {
    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: "plus")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(ColorScheme.clockBtnBgColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    AddEvent()
}
