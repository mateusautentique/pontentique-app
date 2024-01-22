//
//  TimeTextField.swift
//  Pontentique
//
//  Created by Mateus Zanella on 22/01/24.
//

import SwiftUI

struct TimeTextField: View {
    @Binding var registeredTime: String
    var time: String
    @State private var localTime: String = ""
    
    var body: some View {
        TextField("\(time)", text: $localTime)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .padding(5)
            .background(ColorScheme.fieldBgColor)
            .cornerRadius(7)
            .frame(minWidth: 58, maxWidth: 60)
            .onChange (of: localTime){
                let filtered = localTime.filter { "0123456789".contains($0) }
                if filtered.count > 4 {
                    localTime = String(filtered.prefix(4))
                } else if filtered.count == 3 {
                    let timeWithSeparator = insertColonInTime(time: filtered, afterSecondDigit: filtered[filtered.index(filtered.startIndex, offsetBy: 1)] >= "6")
                    if isValidTime(timeWithSeparator) {
                        localTime = timeWithSeparator
                    }
                } else if filtered.count == 4 {
                    let timeWithSeparator = insertColonInTime(time: filtered, afterSecondDigit: true)
                    if isValidTime(timeWithSeparator) {
                        localTime = timeWithSeparator
                    } else {
                        localTime = "23:59"
                    }
                } else {
                    localTime = filtered
                }
                self.registeredTime = localTime
            }
            .onAppear {
                self.localTime = self.registeredTime
            }
    }
    
    func validateAndCorrectTime(time: String) -> String {
        let timeComponents = time.split(separator: ":")
        if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
            if hour > 23 || minute > 59 {
                return "23:59"
            }
        }
        return time
    }
    
    func isValidTime(_ time: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = time.count == 4 ? "H:mm" : "HH:mm"
        if formatter.date(from: time) == nil {
            return false
        }
        
        let components = time.split(separator: ":")
        return components[1].count == 2
    }
    
    func insertColonInTime(time: String, afterSecondDigit: Bool) -> String {
        let index = afterSecondDigit ? 2 : 1
        return time.inserting(separator: ":", at: index)
    }
}

struct TimeTextField_Previews: PreviewProvider {
    @State static var registeredTime = "12:00"
    @State static var time = "12:00"

    static var previews: some View {
        NavigationView {
            TimeTextField(registeredTime: $registeredTime, time: time)
        }
    }
}
