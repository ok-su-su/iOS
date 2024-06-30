//
//  ReceivedFilterHelperProperty.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - FilterHelperProperty

struct FilterHelperProperty: Equatable {
  var selectableLedgers: [FilterSelectableItemProperty] = [
    .init(id: 1, title: "결혼식"),
    .init(id: 2, title: "영결식"),
    .init(id: 3, title: "영춘권"),
    .init(id: 4, title: "곰춘권"),
    .init(id: 5, title: "곰춘권"),
    .init(id: 6, title: "곰춘권"),
    .init(id: 7, title: "곰춘권"),
    .init(id: 8, title: "곰춘권"),
  ]
  var selectedLedgers: [FilterSelectableItemProperty] = []

  var filteredDateTextString: String? {
    guard let startDate else {
      return nil
    }
    let startDateString = CustomDateFormatter.getString(from: startDate, dateFormat: "yyyy.MM.dd")
    guard let endDate else {
      return startDateString
    }
    let endDateString = CustomDateFormatter.getString(from: endDate, dateFormat: "yyyy.MM.dd")
    return startDateString + "~" + endDateString
  }

  var startDate: Date?
  var endDate: Date?

  func isSelectedItems(id: Int64) -> Bool {
    return selectedLedgers.first(where: { $0.id == id }) != nil
  }

  mutating func select(_ id: Int64) {
    // 이미 선택되었다면 제거
    if let index = selectedLedgers.firstIndex(where: { $0.id == id }) {
      selectedLedgers.remove(at: index)
      return
    }

    // 선택이 안되었다면 선택
    if let ledger = selectableLedgers.first(where: { $0.id == id }) {
      selectedLedgers.append(ledger)
    }
  }

  mutating func setStartDate(_ date: Date) {
    startDate = date
  }

  mutating func setEndDate(_ date: Date) {
    endDate = date
  }

  mutating func resetDate() {
    startDate = nil
    endDate = nil
  }

  mutating func setInitialState() {
    resetDate()
    selectedLedgers = []
  }

  mutating func deleteSelectedItem(id: Int64) {
    guard let index = selectedLedgers.firstIndex(where: { $0.id == id }) else {
      return
    }
    selectedLedgers.remove(at: index)
  }
}

// MARK: - FilterSelectableItemProperty

struct FilterSelectableItemProperty: Equatable, Identifiable {
  /// 카테고리 아이디
  var id: Int64
  /// 카테고리 타이틀
  var title: String
}
