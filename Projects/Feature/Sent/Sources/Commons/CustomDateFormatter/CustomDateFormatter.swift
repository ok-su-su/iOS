//
//  CustomDateFormatter.swift
//  Sent
//
//  Created by MaraMincho on 6/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final class CustomDateFormatter {
  private static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }()

  static func getDate(from val: String) -> Date? {
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let targetString = String(val.prefix(19))
    return formatter.date(from: targetString)
  }

  static func getFullDateString(from val: Date) -> String {
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.string(from: val)
  }

  static func getString(from val: Date, dateFormat: String? = nil) -> String {
    if let dateFormat {
      formatter.dateFormat = dateFormat
    }
    return formatter.string(from: val)
  }

  private init() {}
}
