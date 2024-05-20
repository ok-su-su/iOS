//
//  SelectYearItemDateFormatter.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final class SelectYearItemDateFormatter {
  private init() {}

  private static let dateFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter
  }()

  static func yearStringFrom(date: Date) -> String {
    return dateFormatter.string(from: date)
  }

  static func dateFrom(string val: String) -> Date? {
    return dateFormatter.date(from: val)
  }
}
