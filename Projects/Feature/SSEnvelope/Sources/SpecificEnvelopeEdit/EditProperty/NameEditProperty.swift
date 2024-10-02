//
//  NameEditProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSRegexManager

// MARK: - NameEditProperty

/// EditName을 하기 위해 사용됩니다.
struct NameEditProperty: Equatable, EnvelopeEditPropertiable {
  let originalText: String
  var textFieldText: String

  var isValid: Bool {
    RegexManager.isValidName(textFieldText)
  }

  var isChanged: Bool {
    originalText != textFieldText
  }

  var isShowToast: Bool {
    ToastRegexManager.isShowToastByName(textFieldText)
  }

  init(textFieldText: String) {
    self.textFieldText = textFieldText
    originalText = textFieldText
  }
}
