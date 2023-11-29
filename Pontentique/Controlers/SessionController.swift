//
//  ValidateSession.swift
//  Pontentique
//
//  Created by Mateus Zanella on 28/11/23.
//

import Foundation

func validateSession(_ session: String, _ host: String = "https://192.168.1.249:8743") async throws -> Bool {
    var request = URLRequest(url: URL(string: "\(host)/session_is_valid.fcgi?session=\(session)")!,timeoutInterval: Double.infinity)
    request.httpMethod = "POST"

    let delegate = MySessionDelegate()
    let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
    
    let (data, _) = try await session.data(for: request)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
        let validationResponse = try decoder.decode(SessionValidationResponse.self, from: data)
        return validationResponse.sessionIsValid
    } catch {
        throw LoginError.decodingError(error)
    }
}

