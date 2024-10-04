//
//  CustomNumberFormatter.swift
//  Statistics
//
//  Created by MaraMincho on 8/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum CustomNumberFormatter {
  private nonisolated(unsafe) static var numberFormatter = NumberFormatter()

  static func toDecimal(_ val: Int64?) -> String? {
    guard let val else {
      return nil
    }
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(for: val)
  }
}
