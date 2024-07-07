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

struct LedgerDetailEditProperty: Equatable {
  var nameEditProperty: NameEditProperty
  var dateEditProperty: DateEditProperty
  var categoryEditProperty: SingleSelectButtonProperty<CategoryEditProperty>
  var categoryEditCustomItem: CategoryEditProperty

  var isValid: Bool {
    nameEditProperty.isValid &&
      categoryEditProperty.isValid()
  }

  init(ledgerDetailProperty: LedgerDetailProperty, category: [CategoryEditProperty]) {
    var category = category
    nameEditProperty = .init(textFieldText: ledgerDetailProperty.title)
    dateEditProperty = .init(startDate: ledgerDetailProperty.startDate, endDate: ledgerDetailProperty.endDate)
    var customItem: CategoryEditProperty? = nil
    if let customItemID = category.popLast()?.id {
      if let customCategory = ledgerDetailProperty.customCategory {
        customItem = .init(id: customItemID, title: customCategory)
      } else {
        customItem = .init(id: customItemID, title: "")
      }
    }
    categoryEditCustomItem = customItem ?? .init(id: -1, title: "")
    categoryEditProperty = .init(
      titleText: "카테고리",
      items: category,
      isCustomItem: categoryEditCustomItem,
      customTextFieldPrompt: "경조사 이름",
      isEssentialProperty: true
    )
  }

  mutating func changeNameTextField(_ name: String) {
    nameEditProperty.textFieldText = name
  }
}

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
  var isStartDateInitialState = true
  var startDate: Date
  var isShowEndDate = false
  var isEndDateInitialState = true
  var endDate: Date

  var dateText: String {
//    return CustomDateFormatter.getKoreanDateString(from: date)
    ""
  }

  var startDateText: (year: String, month: String, day: String) {
    return (
      CustomDateFormatter.getYear(from: startDate),
      CustomDateFormatter.getMonth(from: startDate),
      CustomDateFormatter.getDay(from: startDate)
    )
  }

  var endDateText: (year: String, month: String, day: String)? {
    if !isShowEndDate {
      return nil
    }
    return (
      CustomDateFormatter.getYear(from: endDate),
      CustomDateFormatter.getMonth(from: endDate),
      CustomDateFormatter.getDay(from: endDate)
    )
  }

  mutating func toggleShowEndDate() {
    if !isShowEndDate {
      isShowEndDate.toggle()
    } else {
      // 만약 시작 날짜보다 종료 날짜가 작다면 이를 반영합니다.
      endDate = startDate < endDate ? endDate : .now
    }
  }

  init(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
    if startDate == endDate {
      isShowEndDate = false
    }
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
