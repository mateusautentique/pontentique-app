//
//  TicketController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 24/01/24.
//

import Foundation

func createTicket(_ ticket: TicketRequest, _ token: String,
                  host: String = "\(API_HOST)/user/ticket",
                  completion: @escaping (String?, Error?)
                  -> (Void))
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "POST"
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    request.httpBody = try? encoder.encode(ticket)
    
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

func handleTicket(_ ticketId: Int, _ action: String, _ token: String,
                  host: String = "\(API_HOST)/admin/manageTickets/handle",
                  completion: @escaping (String?, Error?)
                  -> (Void))
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "PUT"
    
    let parameters: [String: Any] = [
        "ticket_id": "\(ticketId)",
        "action": action
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

func getAllActiveTickets(_ token: String, host: String = "\(API_HOST)/admin/manageTickets/active",
                         completion: @escaping (Result<[Ticket], Error>) -> Void)
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "GET"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let response = response as? HTTPURLResponse, let data = data else {
            completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        do {
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                let tickets = try decoder.decode([Ticket].self, from: data)
                completion(.success(tickets))
            } else {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let error = createError(from: json, with: response.statusCode)
                    completion(.failure(error))
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
            completion(.failure(error))
        }
    }
    task.resume()
}
