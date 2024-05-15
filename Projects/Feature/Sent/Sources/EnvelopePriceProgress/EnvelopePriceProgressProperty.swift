//
//  EnvelopePriceProgressProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct EnvelopePriceProgressProperty: Equatable {
  /// 소숫점으로 표시됩니다.
  var progressValue: Double {
    if leadingPriceValue + trailingPriceValue <= 0 {
      return 0.5
    }
    return Double(leadingPriceValue) / Double(leadingPriceValue + trailingPriceValue)
  }

  var leadingDescriptionText: String = "보냈어요"
  var trailingDescriptionText: String = "받았어요"

  var leadingPriceValue: Int
  var trailingPriceValue: Int

  var leadingPriceText: String {
    return CustomNumberFormatter.formattedByThreeZero(leadingPriceValue) ?? ""
  }

  var trailingPriceText: String {
    return CustomNumberFormatter.formattedByThreeZero(trailingPriceValue) ?? ""
  }

  static func makeFakeData() -> Self {
    EnvelopePriceProgressProperty(leadingPriceValue: 1500, trailingPriceValue: 50000)
  }
}
