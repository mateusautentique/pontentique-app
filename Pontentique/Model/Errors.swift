//
//  Errors.swift
//  Pontentique
//
//  Created by Mateus Zanella on 28/11/23.
//

import Foundation

enum LoginError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
}
