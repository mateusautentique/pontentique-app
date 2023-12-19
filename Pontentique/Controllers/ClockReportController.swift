//
//  ClockReportLoader.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/12/23.
//

import Foundation

class ClockReportController: ObservableObject {
    @Published var clockReport: ClockReport?

    init() {
        loadClockReport()
    }

    func loadClockReport() {
        do {
            let url = Bundle.main.url(forResource: "ReportExampleData", withExtension: "json")!
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddHHmmss)
            self.clockReport = try decoder.decode(ClockReport.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            self.clockReport = ClockReport(userId: 1, userName: "", totalHoursWorked: "", totalNormalHoursWorked: "", totalHourBalance: "", entries: [])
        }
    }
}
