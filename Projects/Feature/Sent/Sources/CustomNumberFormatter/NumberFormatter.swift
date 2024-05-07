//
//  NumberFormatter.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum CustomNumberFormatter {
  static let numberFormatter = NumberFormatter()

  static func formattedByThreeZero(_ val: Int) -> String? {
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(for: val)
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
