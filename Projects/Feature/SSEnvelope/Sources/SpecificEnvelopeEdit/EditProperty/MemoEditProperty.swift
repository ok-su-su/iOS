//
//  MemoEditProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSRegexManager

// MARK: - MemoEditProperty

struct MemoEditProperty: Equatable, EnvelopeEditPropertiable {
  let originalMemo: String
  var memo: String
  init(memo: String?) {
    let memo = memo ?? ""
    self.memo = memo
    originalMemo = memo
  }

  var isValid: Bool {
    if !memo.isEmpty {
      return RegexManager.isValidMemo(memo)
    }
    return true
  }

  var isChanged: Bool {
    originalMemo != memo
  }

  var isShowToast: Bool {
    if !memo.isEmpty {
      return ToastRegexManager.isShowToastByMemo(memo)
    }
    return false
  }
}
