//
//  DataFetcherController.swift
//  Pontentique
//
//  Created by Mateus Zanella on 10/01/24.
//

import Foundation

class DataFetcher: ObservableObject {
    @Published var clockReport: ClockReport?

    func fetchClockReport(_ startDate: String, _ endDate: String, sessionManager: UserSessionManager, completion: @escaping (ClockReport?) -> Void) {
        if case let .loggedIn(token, id, _) = sessionManager.session {
            getClockEntriesByPeriod(id, token, startDate: startDate, endDate: endDate) { (clockReport, error) in
                if let clockReport = clockReport {
                    DispatchQueue.main.async {
                        self.clockReport = clockReport
                        completion(clockReport)
                    }
                } else if let error = error {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
}