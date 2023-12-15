//
//  LoginViewController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 28/11/23.
//

import Foundation

func userLogin (_ cpf: String, _ password: String, host: String = "\(API_HOST)/login", completion: @escaping (String?, Error?) -> Void) {
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "POST"
    
    let parameters: [String: Any] = [
        "cpf": "\(cpf)",
        "password": "\(password)"
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if response.statusCode == 200 {
                    if let token = json["token"] as? String {
                        // handle token
                        completion(token, nil)
                    }
                } else {
                    let error = createError(from: json, with: response.statusCode)
                    completion(nil, error)
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
            completion(nil, error)
        }
    }
    task.resume()
}

func userLogout(_ token: String, host: String = "\(API_HOST)/logout") {
    
}

func userRegister(cpf: String, name: String, email: String, password: String, password_confirmation: String, host: String = "\(API_HOST)/register") {
    
}

func validateSessionToken (_ token: String, host: String = "\(API_HOST)/validateToken") {
    
}

func getLoggedUser (_ token: String, host: String = "\(API_HOST)/user") {
    
}

// ERROR HANDLING

func createError(from json: [String: Any], with statusCode: Int) -> NSError {
    var errorMessage: String?
    var userInfo = [String: Any]()
    
    if statusCode == 401 {
        errorMessage = json["error"] as? String
    } else if statusCode == 422 {
        errorMessage = json["message"] as? String
        if let errorsDict = json["errors"] as? [String: Any] {
            for (field, fieldError) in errorsDict {
                if let fieldError = fieldError as? [String] {
                    userInfo[field] = fieldError.joined(separator: ", ")
                }
            }
        }
    } else {
        errorMessage = json["message"] as? String
    }
    
    userInfo[NSLocalizedDescriptionKey] = errorMessage
    return NSError(domain: "", code: statusCode, userInfo: userInfo)
}
