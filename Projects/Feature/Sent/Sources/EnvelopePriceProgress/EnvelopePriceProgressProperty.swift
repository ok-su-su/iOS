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

  var leadingPriceValue: Int64
  var trailingPriceValue: Int64

  var leadingDescriptionText: String = "보냈어요"
  var trailingDescriptionText: String = "받았어요"

  init(leadingPriceValue: Int64, trailingPriceValue: Int64) {
    self.leadingPriceValue = leadingPriceValue
    self.trailingPriceValue = trailingPriceValue
  }

  var leadingPriceText: String {
    return CustomNumberFormatter.formattedByThreeZero(leadingPriceValue, subFixString: "원") ?? ""
  }

  var trailingPriceText: String {
    return CustomNumberFormatter.formattedByThreeZero(trailingPriceValue, subFixString: "원") ?? ""
  }
}
