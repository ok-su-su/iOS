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
  var selectableCategories: [FilterSelectableItemProperty] = []
  var selectedCategories: [FilterSelectableItemProperty] = []

  var selectedFilterDateTextString: String? {
    let endDateString = CustomDateFormatter.getString(from: endDate, dateFormat: "yyyy.MM.dd")
    let startDateString = CustomDateFormatter.getString(from: startDate, dateFormat: "yyyy.MM.dd")
    switch (isInitialStateOfStartDate, isInitialStateOfEndDate) {
    case (true, true):
      return nil
    case (true, false):
      return "~" + endDateString
    case (false, true):
      return startDateString
    case (false, false):
      return startDateString + "~" + endDateString
    }
  }

  var isInitialStateOfStartDate: Bool = true
  var startDate: Date = .now
  var isInitialStateOfEndDate: Bool = true
  var endDate: Date = .now

  mutating func updateDateOf(startDate: Date?, endDate: Date?) {
    resetDate()
    if let startDate {
      self.startDate = startDate
      isInitialStateOfStartDate = false
    }

    if let endDate {
      self.endDate = endDate
      isInitialStateOfEndDate = false
    }
  }

  func isSelectedItems(id: FilterSelectableItemProperty.ID) -> Bool {
    return selectedCategories.first(where: { $0.id == id }) != nil
  }

  mutating func select(_ id: FilterSelectableItemProperty.ID) {
    // 이미 선택되었다면 제거
    if let index = selectedCategories.firstIndex(where: { $0.id == id }) {
      selectedCategories.remove(at: index)
      return
    }

    // 선택이 안되었다면 선택
    if let category = selectableCategories.first(where: { $0.id == id }) {
      selectedCategories.append(category)
    }
  }

  mutating func selectItems(_ items: [FilterSelectableItemProperty]) {
    selectedCategories = items
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
    selectedCategories = []
  }

  mutating func deleteSelectedItem(id: FilterSelectableItemProperty.ID) {
    guard let index = selectedCategories.firstIndex(where: { $0.id == id }) else {
      return
    }
    selectedCategories.remove(at: index)
  }
}
