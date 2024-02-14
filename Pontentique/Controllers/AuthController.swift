//
//  LoginViewController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 28/11/23.
//

import Foundation

// MARK: - AUTH

func userLogin (_ cpf: String, _ password: String, host: String = "\(API_HOST)/login",
                completion: @escaping (String?, Error?) -> Void)
{
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
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if response.statusCode == 200 {
                    if let token = json["token"] as? String {
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

func userRegister(cpf: String, pis: String, name: String, email: String, 
                  password: String, password_confirmation: String,
                  host: String = "\(API_HOST)/register", completion: @escaping
                  (String?, Int?, Error?) -> Void)
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "POST"
    
    let parameters: [String: Any] = [
        "name": "\(name)",
        "email": "\(email)",
        "password": "\(password)",
        "password_confirmation": "\(password_confirmation)",
        "cpf": "\(cpf)",
        "pis": "\(pis)",
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(nil, nil, error)
            return
        }
        
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if response.statusCode == 200 {
                    if let token = json["token"] as? String {
                        completion(token, response.statusCode, nil)
                    }
                } else {
                    let error = createError(from: json, with: response.statusCode)
                    completion(json["error"] as? String, response.statusCode, error)
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
            completion(nil, response.statusCode, error)
        }
    }
    task.resume()
}

func getLoggedUser(_ token: String, host: String = "\(API_HOST)/user/", 
                   completion: @escaping (User?, Error?) -> Void)
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "GET"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        do {
            if response.statusCode == 200 {
                var user = try userDecoder().decode(User.self, from: data)
                user.token = token
                completion(user, nil)
            } else {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
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
