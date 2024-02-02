//
//  WeekendView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import SwiftUI

struct WeekendView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 0){
            Text("Folga")
                .padding(7)
                .frame(width: 62)
                .fixedSize()
                .background(ColorScheme.textColor.opacity(0.17))
                .foregroundStyle(ColorScheme.textColor.opacity(0.50))
                .cornerRadius(10)
        }
    }
}

struct WeekendView_Previews: PreviewProvider {
    static var previews: some View {
        WeekendView()
    }
}
