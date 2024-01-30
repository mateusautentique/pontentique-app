//
//  ClockPunchController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 20/12/23.
//

import Foundation

func punchClock(_ userId: Int, _ token: String, host: String = "\(API_HOST)/user/punchClock", 
                completion: @escaping (String?, Error?)
                -> (Void))
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "POST"
    
    let parameters: [String: Any] = [
        "user_id": "\(userId)",
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
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
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if response.statusCode == 200 {
                    if let message = json["message"] as? String {
                        completion(message, nil)
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
