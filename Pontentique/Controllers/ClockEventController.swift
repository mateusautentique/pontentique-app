//
//  ClockEventController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 22/12/23.
//

import Foundation

func editClockEvent(_ id: Int,_ timestamp: String,_ justification: String,
                    _ token: String, _ dayOff: Bool, _ doctor: Bool,
                    host: String = "\(API_HOST)/admin/userEntries",
                    completion: @escaping (String?, Error?)
                    -> (Void))
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "PUT"
    
    let parameters: [String: Any] = [
        "id": "\(id)",
        "timestamp": "\(timestamp)",
        "justification": "\(justification)",
        "doctor": doctor ? 1 : 0,
        "day_off": dayOff ? 1 : 0
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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

func addClockEvent(_ userId: Int,_ timestamp: String,_ justification: String,
                    _ token: String, _ dayOff: Bool, _ doctor: Bool,
                    host: String = "\(API_HOST)/admin/userEntries",
                    completion: @escaping (String?, Error?)
                    -> (Void))
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "POST"
    
    let parameters: [String: Any] = [
        "user_id": "\(userId)",
        "timestamp": "\(timestamp)",
        "justification": "\(justification)",
        "doctor": doctor ? 1 : 0,
        "day_off": dayOff ? 1 : 0
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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

func deleteClockEvent(_ id: Int, _ token: String, completion: @escaping (String?, Error?) -> (Void))
{
    let host = "\(API_HOST)/admin/userEntries/\(id)"
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "DELETE"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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

func setDayOffForDate(_ userId: Int, _ justification: String, _ startDate: String, _ startTime: String,
                      _ endDate: String, _ endTime: String, _ dayOff: Bool, _ doctor: Bool, _ token: String,
                      host: String = "\(API_HOST)/admin/userEntries/setDayOff", completion: @escaping (String?, Error?)
                      -> (Void))
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "POST"
    
    let parameters: [String: Any] = [
        "user_id": "\(userId)",
        "justification": "\(justification)",
        "start_date": startDate,
        "start_time": startTime,
        "end_date": endDate,
        "end_time": endTime,
        "doctor": doctor ? 1 : 0,
        "day_off": dayOff ? 1 : 0
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
