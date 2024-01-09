//
//  APIClockReportController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 20/12/23.
//

import Foundation

func getClockEntriesByPeriod(_ userId: Int, _ token: String, startDate: String?, endDate: String?,
                             host: String = "\(API_HOST)/user/userEntries", completion: @escaping (ClockReport?, Error?)
                             -> (Void))
{
    var request = URLRequest(url: URL(string: host)!)
    request.httpMethod = "POST"
    
    let startDate = startDate ?? ""
    let endDate = endDate ?? ""
    
    let parameters: [String: Any] = [
        "user_id": "\(userId)",
        "start_date": startDate,
        "end_date": endDate
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        do {
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let clockReport = try decoder.decode(ClockReport.self, from: data)
                completion(clockReport, nil)
            } else {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let error = createError(from: json ?? [:], with: response.statusCode)
                completion(nil, error)
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil, error)
        }
    }
    task.resume()
}
