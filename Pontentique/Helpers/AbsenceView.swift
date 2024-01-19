//
//  AbsenceView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import SwiftUI

import SwiftUI

struct AbsenceView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("Falta")
                .padding(7)
                .frame(width: 60)
                .fixedSize()
                .background(ColorScheme.BackAbsDay)
                .foregroundColor(ColorScheme.AbsDay)
                .cornerRadius(10)
                .padding(.trailing, 5)
        }
    }
}

#Preview {
    AbsenceView()
}
