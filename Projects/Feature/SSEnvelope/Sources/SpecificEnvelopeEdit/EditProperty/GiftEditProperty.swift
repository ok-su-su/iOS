//
//  GiftEditProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSRegexManager

// MARK: - GiftEditProperty

struct GiftEditProperty: Equatable, EnvelopeEditPropertiable {
  let originalGift: String
  var gift: String

  init(gift: String?) {
    let gift = gift ?? ""
    self.gift = gift
    originalGift = gift
  }

  var isValid: Bool {
    if !gift.isEmpty {
      return RegexManager.isValidGift(gift)
    }
    return true
  }

  var isChanged: Bool {
    originalGift != gift
  }

  var isShowToast: Bool {
    if !gift.isEmpty {
      return ToastRegexManager.isShowToastByGift(gift)
    }
    return false
  }
}
