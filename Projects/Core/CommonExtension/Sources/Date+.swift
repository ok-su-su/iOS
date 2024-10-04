//
//  Date+.swift
//  CommonExtension
//
//  Created by MaraMincho on 8/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public extension String {
  private static let ISODateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Constants.iso8601DateFormatWithoutMiliSeconds
    return dateFormatter
  }()

  func fromISO8601ToDate() -> Date? {
    Self.ISODateFormatter.date(from: self)
  }

  private enum Constants {
    static let iso8601DateFormatWithoutMiliSeconds: String = "yyyy-MM-dd'T'HH:mm:ss"
  }
}
