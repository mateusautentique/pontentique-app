//
//  DoctorVIew.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 23/01/24.
//

import SwiftUI

struct DoctorView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 0){
                Text("Med")
                    .padding(7)
                    .frame(width: 60)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(ColorScheme.textColor.opacity(0.17))
                    .foregroundColor(ColorScheme.textColor.opacity(0.50))
                    .cornerRadius(10)
    
        }
    }
}

struct DoctorView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorView()
    }
}
