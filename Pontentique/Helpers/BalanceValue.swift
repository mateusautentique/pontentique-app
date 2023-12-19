//
//  BalanceValue.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct BalanceValue: View {
    @State var balanceHours: String
    
    var body: some View {
        HStack {
            if checkBalanceValue(balanceHours) > 0 {
                Text(balanceHours)
                    .foregroundColor(Color.green)
            } else if checkBalanceValue(balanceHours) == 0 {
                Text(balanceHours)
                    .foregroundColor(Color.white)
            } else {
                Text(balanceHours)
                    .foregroundColor(Color.red)
            }
        }
        .onAppear{
            balanceHours = balanceHours.first == "-" ? balanceHours : "+" + balanceHours
        }
    }
}

func checkBalanceValue(_ duration: String) -> Int {
    let components = duration.split(separator: ":")
    if let hours = Int(components[0]), let minutes = Int(components[1]) {
        return hours * 60 + minutes
    } else {
        return 0
    }
}

#Preview {
    BalanceValue(balanceHours: "0:00")
}
