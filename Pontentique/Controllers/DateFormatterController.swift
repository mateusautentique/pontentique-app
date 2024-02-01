//
//  DateFormatterController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 11/01/24.
//

import Foundation

func createFormatter(_ format: String) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_GB")
    formatter.dateFormat = format
    return formatter
}
