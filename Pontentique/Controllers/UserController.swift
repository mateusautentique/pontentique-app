//
//  UserController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/01/24.
//

import Foundation

func getAllUsers (_ token: String, host: String = "\(API_HOST)/admin/manageUsers/",
                  completion: @escaping ([User]?, Error?) -> Void)
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

func getUserById (_ token: String, _ userId: Int,
                  completion: @escaping (User?, Error?) -> Void)
{
    let host: String = "\(API_HOST)/admin/manageUsers/user/\(userId)"
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
                let users = try userDecoder().decode(User.self, from: data)
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

func editUser(userId: Int, name: String, email: String, cpf: String, pis: String, role: String = "user",
              workJourneyHours: Int = 8, token: String, host: String = "\(API_HOST)/admin/manageUsers/user/",
              completion: @escaping (User?, Error?) -> Void)
{
     
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "PUT"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let parameters: [String: Any] = [
        "user_id": userId,
        "name": name,
        "email": email,
        "cpf": cpf,
        "pis": pis,
        "role": role,
        "work_journey_hours": workJourneyHours
    ]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
    } catch {
        print("Error encoding parameters: \(error)")
        completion(nil, error)
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if response.statusCode == 200 {
                    let user = try userDecoder().decode(User.self, from: data)
                    completion(user, nil)
                } else {
                    let error = createError(from: json, with: response.statusCode)
                    print("ⓘ\(error)")
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

func deleteUser(userId: Int, token: String, completion: @escaping (Bool, Error?) -> Void) {
    let url = URL(string: "\(API_HOST)/admin/manageUsers/user/\(userId)")!
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            completion(false, error)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            completion(true, nil)
        } else {
            completion(false, nil)
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

