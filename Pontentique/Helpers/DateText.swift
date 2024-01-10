//
//  DateText.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import SwiftUI

struct DateText: View {
    var date: String
    var body: some View {
        Text(dateFormat(date))
            .foregroundColor(isEventToday(date) ? ColorScheme.todaysColor : ColorScheme.tableTextColor)
            .padding(.leading, 6)
            .padding(.trailing, 10)
            .frame(width: 60)
    }
}

struct DateText_Previews: PreviewProvider {
    static var previews: some View {
        DateText(date: "1/12")
    }
}

