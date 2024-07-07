//
//  LedgerDetailEditProperty.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton
import SSRegexManager

// MARK: - LedgerDetailEditProperty

struct LedgerDetailEditProperty: Equatable {}

// MARK: - NameEditProperty

/// EditName을 하기 위해 사용됩니다.
struct NameEditProperty: Equatable {
  var textFieldText: String

  var isValid: Bool {
    RegexManager.isValidName(textFieldText)
  }

  var isShowToast: Bool {
    ToastRegexManager.isShowToastByName(textFieldText)
  }
}

// MARK: - DateEditProperty

struct DateEditProperty: Equatable {
  var date: Date

  var dateText: String {
    return CustomDateFormatter.getKoreanDateString(from: date)
  }

  init(date: Date) {
    self.date = date
  }
}

// MARK: - CategoryEditProperty

public struct CategoryEditProperty: Equatable, Identifiable, SingleSelectButtonItemable {
  public var id: Int
  public var title: String

  mutating func setTitle(_ val: String) {
    title = val
  }

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}
