//
//  UserViewModel.swift
//  Pontentique
//
//  Created by Guilherme Luiz Cella on 24/01/24.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users = [User]()

    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let url = URL(string: "http://localhost:8000/api/admin/manageUsers")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = users
                }
                completion(users, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
