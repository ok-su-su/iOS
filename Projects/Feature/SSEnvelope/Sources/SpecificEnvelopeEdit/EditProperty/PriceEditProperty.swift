//
//  PriceEditProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSRegexManager

// MARK: - PriceEditProperty

struct PriceEditProperty: Equatable, EnvelopeEditPropertiable {
  let originalPriceValue: String
  var price: Int64
  var priceTextFieldText: String
  var priceText: String {
    CustomNumberFormatter.formattedByThreeZero(price, subFixString: "원") ?? ""
  }

  init(price: Int64) {
    self.price = price
    priceTextFieldText = price.description
    originalPriceValue = price.description
  }

  mutating func setPriceTextFieldText(_ text: String) {
    priceTextFieldText = text.isEmpty ? "0" : text
    guard let currentValue = Int64(priceTextFieldText) else {
      return
    }
    price = currentValue
  }

  var isValid: Bool {
    RegexManager.isValidPrice(priceTextFieldText)
  }

  var isChanged: Bool {
    originalPriceValue != priceTextFieldText
  }

  var isShowToast: Bool {
    ToastRegexManager.isShowToastByPrice(priceTextFieldText)
  }
}
