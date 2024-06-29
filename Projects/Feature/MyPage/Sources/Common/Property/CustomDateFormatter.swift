//
//  CustomDateFormatter.swift
//  MyPage
//
//  Created by MaraMincho on 6/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum CustomDateFormatter {
  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter
  }()

  static func getDate(from val: String) -> Date? {
    return dateFormatter.date(from: val)
  }

  static func getYear(from date: Date) -> String {
    dateFormatter.string(from: date)
  }
}
