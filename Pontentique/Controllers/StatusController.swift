//
//  StatusController.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 24/01/24.
//

import Foundation

func fetchUserStatus(userId: String, token: String, completion: @escaping (String?, Error?) -> Void) {
    
    let url = URL(string: "http://localhost:8000/api/admin/manageUsers/user/status")!
    let parameters = ["user_id": userId]
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    request.httpBody = jsonData

    print("Request: \(request)")
    print("Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "no body")")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            completion(nil, error)
        } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    let status = json["message"] as? String
                    print("Response JSON: \(json)")
                    completion(status, nil)
                }
            } catch {
                print("JSON Parsing Error: \(error)")
                completion(nil, error)
            }
        }
    }
    task.resume()
}
