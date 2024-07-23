//
//  NumberFormatter.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

enum CustomNumberFormatter {
  static var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }

  static func formattedByThreeZero(_ val: Int, subFixString: String? = nil) -> String? {
    numberFormatter.numberStyle = .decimal
    guard let formatterString = numberFormatter.string(for: val) else {
      return nil
    }
    return formatterString + (subFixString ?? "")
  }

  static func formattedByThreeZero(_ val: Int64, subFixString: String? = nil) -> String? {
    numberFormatter.numberStyle = .decimal
    guard let formatterString = numberFormatter.string(for: val) else {
      return nil
    }
    return formatterString + (subFixString ?? "")
  }

  static func priceToInt(_ val: String) -> Int? {
    let converted = val.map { String($0) }.compactMap { Int($0) }.map { String($0) }.joined()
    return Int(converted)
  }

  static func formattedByThreeZero(_ val: String) -> String? {
    let val = val.map { String($0) }.compactMap { Int($0) }.map { String($0) }
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(for: Int(val.joined()))
  }
}
