//
//  EnvelopePriceProgressProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct EnvelopePriceProgressProperty: Equatable {
  var progressValue: Double = 0.5
  
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
  
}
