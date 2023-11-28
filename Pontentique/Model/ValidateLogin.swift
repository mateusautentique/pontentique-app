//
//  ValidateLogin.swift
//  Pontentique
//
//  Created by Mateus Zanella on 27/11/23.
//

import Foundation

func validateLogin (_ login: String, _ password: String, _ host: String = "https://192.168.1.249:8743") async throws -> SessionInfo {
    let parameters = "{\n    \"login\": \"\(login)\",\n    \"password\": \"\(password)\"\n}"
    let postData = parameters.data(using: .utf8)
    
    guard let url = URL(string: "\(host)/login.fcgi") else {
        throw LoginError.invalidURL
    }
    
    var request = URLRequest(url: url,timeoutInterval: Double.infinity)
    request.httpMethod = "POST"
    request.httpBody = postData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let delegate = MySessionDelegate()
    let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
    
    let (data, _) = try await session.data(for: request)
    
    let decoder = JSONDecoder()
    do {
        let sessionToken = try decoder.decode(SessionInfo.self, from: data)
        return sessionToken
    } catch {
        throw LoginError.decodingError(error)
    }
}
