//
//  BalanceValue.swift
//  Pontentique
//
//  Created by Mateus Zanella on 18/12/23.
//

import SwiftUI

struct BalanceValue: View {
    @Binding var balanceHours: String

    var formattedBalanceHours: String {
        let hours = (balanceHours.isEmpty == false) ? balanceHours : "0:00"
        return hours.first == "-" ? hours : "+" + hours
    }
    
    var body: some View {
        HStack {
            if checkBalanceValue((balanceHours.isEmpty == false) ? balanceHours : "0:00") > 0 {
                Text(formattedBalanceHours)
                    .foregroundStyle(Color.green)
            } else if checkBalanceValue((balanceHours.isEmpty == false) ? balanceHours : "0:00") == 0 {
                Text(formattedBalanceHours)
                    .foregroundStyle(ColorScheme.textColor)
            } else {
                Text(formattedBalanceHours)
                    .foregroundStyle(Color.red)
            }
        }
    }
}

func checkBalanceValue(_ duration: String) -> Int {
    let components = duration.split(separator: ":")
    if duration.first == "-" {
        if let hours = Int(String(components[0].dropFirst())), let minutes = Int(components[1]) {
            let totalMinutes = hours * 60 + minutes
            return -totalMinutes
        }
    } else {
        if let hours = Int(components[0]), let minutes = Int(components[1]) {
            let totalMinutes = hours * 60 + minutes
            return totalMinutes
        }
    }
    return 0
}

struct BalanceValue_Previews: PreviewProvider {
    @State static var balanceHours = "0:00"

    static var previews: some View {
        BalanceValue(balanceHours: $balanceHours)
    }
}
