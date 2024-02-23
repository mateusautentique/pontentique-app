//
//  DateTextField.swift
//  Pontentique
//
//  Created by Mateus Zanella on 22/01/24.
//

import SwiftUI

struct DateTextField: View {
    @Binding var registeredDate: String
    var dayAndMonth: String
    @State private var localDate: String = ""
    
    var body: some View {
        TextField("\(dayAndMonth)", text: $localDate)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .padding(5)
            .background(ColorScheme.fieldBgColor)
            .cornerRadius(7)
            .frame(minWidth: 58, maxWidth: 60)
            .onChange(of: localDate) {
                let filtered = localDate.filter { "0123456789".contains($0) }
                if filtered.count > 4 {
                    localDate = String(filtered.prefix(4))
                } else if filtered.count == 2 {
                    let dateWithSeparator = insertSlashInDate(date: filtered)
                    if isValidDate(dateWithSeparator) {
                        localDate = dateWithSeparator
                    }
                } else if filtered.count == 4 {
                    let dateWithSeparator = insertSlashInDate(date: filtered)
                    if isValidDate(dateWithSeparator) {
                        localDate = dateWithSeparator
                    }
                } else {
                    localDate = filtered
                }
                self.registeredDate = localDate
            }
            .onAppear {
                self.localDate = self.registeredDate
            }
    }
    
    func isValidDate(_ date: String) -> Bool {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "dd/MM"
        if formatter.date(from: date) == nil {
            return false
        }
        
        let components = date.split(separator: "/")
        return components[1].count == 2
    }
    
    func insertSlashInDate(date: String) -> String {
        return date.inserting(separator: "/", at: 2)
    }
}

struct DateTextField_Previews: PreviewProvider {
    @State static var date = "01/01"

    static var previews: some View {
        DateTextField(registeredDate: $date, dayAndMonth: "01/01")
    }
}
