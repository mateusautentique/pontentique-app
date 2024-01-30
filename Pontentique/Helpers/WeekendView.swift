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
                    .background(Color.white.opacity(0.17))
                    .foregroundColor(Color.white.opacity(0.50))
                    .cornerRadius(10)
        }
    }
}

struct WeekendView_Previews: PreviewProvider {
    static var previews: some View {
        WeekendView()
    }
}
