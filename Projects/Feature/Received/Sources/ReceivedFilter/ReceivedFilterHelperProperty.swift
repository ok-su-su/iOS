//
//  ReceivedFilterHelperProperty.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - FilterHelperProperty

struct FilterHelperProperty: Equatable, Sendable {
  var selectableLedgers: [FilterSelectableItemProperty] = []
  var selectedLedgers: [FilterSelectableItemProperty] = []

  var selectedFilterDateTextString: String? {
    if isInitialStateOfStartDate {
      return nil
    }
    let startDateString = CustomDateFormatter.getString(from: startDate, dateFormat: "yyyy.MM.dd")
    if isInitialStateOfEndDate {
      return startDateString
    }
    let endDateString = CustomDateFormatter.getString(from: endDate, dateFormat: "yyyy.MM.dd")
    return startDateString + "~" + endDateString
  }

  var isInitialStateOfStartDate: Bool = true
  var startDate: Date = .now
  var isInitialStateOfEndDate: Bool = true
  var endDate: Date = .now

  func isSelectedItems(id: Int) -> Bool {
    return selectedLedgers.first(where: { $0.id == id }) != nil
  }

  mutating func select(_ id: Int) {
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
    isInitialStateOfStartDate = true
    startDate = .now

    isInitialStateOfEndDate = true
    endDate = .now
  }

  mutating func setInitialState() {
    resetDate()
    selectedLedgers = []
  }

  mutating func deleteSelectedItem(id: Int) {
    guard let index = selectedLedgers.firstIndex(where: { $0.id == id }) else {
      return
    }
    selectedLedgers.remove(at: index)
  }
}
