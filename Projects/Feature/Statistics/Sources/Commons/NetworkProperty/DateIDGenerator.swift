//
//  DateIDGenerator.swift
//  Statistics
//
//  Created by MaraMincho on 8/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum DateIDGenerator {
  static func generateLatestMonthDateIDAndMonth(_ latestMonth: Int = 6) -> [(id: Int64, month: Int)] {
    let currentDate = Date()
    var latestSixMonths: [(Int64, Int)] = []

    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMM"

    for i in 0 ..< latestMonth {
      if let pastDate = calendar.date(byAdding: .month, value: -i, to: currentDate) {
        let formattedDate = dateFormatter.string(from: pastDate)
        if let dateInt = Int64(formattedDate) {
          latestSixMonths.append((dateInt, Int(dateInt) % 100))
        }
      }
    }

    return latestSixMonths.reversed()
  }
}
