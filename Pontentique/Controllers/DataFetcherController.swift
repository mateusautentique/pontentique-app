//
//  DataFetcherController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import Foundation

class DataFetcher: ObservableObject {
    @Published var clockReport: ClockReport?
    @Published var userArray: [User]?
    
    func fetchClockReport(_ startDate: String, _ endDate: String,
                          sessionManager: UserSessionManager, selectedUser: User,
                          completion: @escaping (ClockReport?, Error?) -> Void) {
        if let user = sessionManager.user {
            getClockEntriesByPeriod(selectedUser.id, user.token ?? "", startDate: startDate, endDate: endDate)
            {
                (clockReport, error) in
                if let clockReport = clockReport {
                    DispatchQueue.main.async {
                        self.clockReport = clockReport
                        completion(clockReport, nil)
                    }
                } else if let error = error {
                    print(error)
                    completion(nil, error)
                }
            }
        }
    }

    func fetchAllUsers(sessionManager: UserSessionManager,
                       completion: @escaping ([User]?, Error?) -> Void){
        if let user = sessionManager.user {
            getAllUsers(user.token ?? "") {
                (userArray, error) in
                if let userArray = userArray {
                    DispatchQueue.main.async {
                        self.userArray = userArray
                        completion(userArray, nil)
                    }
                } else if let error = error {
                    print(error)
                    completion(nil, error)
                }
            }
        }
    }
}
