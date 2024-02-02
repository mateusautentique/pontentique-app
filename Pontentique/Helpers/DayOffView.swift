//
//  DayOffView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 01/02/24.
//

import SwiftUI

struct DayOffView: View {
    var text: String
    var backgroundOpacity: Double
    var foregroundOpacity: Double

    var body: some View {
        Text(text)
            .padding(7)
            .frame(width: 62)
            .fixedSize()
            .background(ColorScheme.textColor.opacity(backgroundOpacity))
            .foregroundStyle(ColorScheme.textColor.opacity(foregroundOpacity))
    }
}

#Preview {
    DayOffView(text: "Folga", backgroundOpacity: 0.17, foregroundOpacity: 0.50)
}
