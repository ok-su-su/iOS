//
//  Date+.swift
//  CommonExtension
//
//  Created by MaraMincho on 8/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public extension String {
  private static let ISO8601DateFormatter: ISO8601DateFormatter = .init()

  func fromISO8601ToDate() -> Date? {
    Self.ISO8601DateFormatter.date(from: self)
  }
}
