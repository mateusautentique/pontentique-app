//
//  UserController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/01/24.
//

import Foundation

func getAllUsers (_ token: String, host: String = "\(API_HOST)/admin/manageUsers/", completion: @escaping ([User]?, Error?) -> Void) {
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "GET"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        do {
            if response.statusCode == 200 {
                let users = try userDecoder().decode([User].self, from: data)
                completion(users, nil)
            } else {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let error = createError(from: json as! [String : Any], with: response.statusCode)
                completion(nil, error)
            }
        } catch {
            print("Error parsing JSON: \(error)")
            completion(nil, error)
        }
    }
    task.resume()
}

// MARK: - UTILS
func userDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    decoder.dateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
    }
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}
