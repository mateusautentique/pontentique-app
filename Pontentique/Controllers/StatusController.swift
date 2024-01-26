//
//  StatusController.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 24/01/24.
//

import Foundation

func fetchUserStatus(userId: String, token: String, completion: @escaping (String?, Error?) -> Void) {
    
    let url = URL(string: "\(API_HOST)/admin/manageUsers/user/status")!
    let parameters = ["user_id": userId]
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    request.httpBody = jsonData


    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, error)
        } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    let status = json["message"] as? String
                    completion(status, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
    task.resume()
}
