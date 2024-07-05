//
//  LedgerDetailFilterProperty.swift
//  Received
//
//  Created by MaraMincho on 7/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - LedgerDetailFilterProperty

struct LedgerDetailFilterProperty: Equatable {
  var selectableItems: [LedgerFilterItemProperty] = []
  var selectedItems: [LedgerFilterItemProperty] = []

  var highestAmount: Int64? = nil
  var lowestAmount: Int64? = nil

  var amountFilterBadgeText: String? {
    guard let highestAmount,
          let lowestAmount,
          let lowVal = CustomNumberFormatter.formattedByThreeZero(lowestAmount, subFixString: nil),
          let highVal = CustomNumberFormatter.formattedByThreeZero(highestAmount, subFixString: nil)
    else {
      return nil
    }
    return "\(lowVal)~\(highVal)"
  }

  func isSelectedItems(id: Int64) -> Bool {
    return selectedItems.first(where: { $0.id == id }) != nil
  }

  mutating func select(_ id: Int64) {
    // 이미 선택되었다면 제거
    if let index = selectedItems.firstIndex(where: { $0.id == id }) {
      selectedItems.remove(at: index)
      return
    }

    // 선택이 안되었다면 선택
    if let ledger = selectableItems.first(where: { $0.id == id }) {
      selectedItems.append(ledger)
    }
  }

  mutating func deleteSelectedItem(id: Int64) {
    guard let index = selectedItems.firstIndex(where: { $0.id == id }) else {
      return
    }
    selectedItems.remove(at: index)
  }

  mutating func reset() {
    selectedItems = []
    highestAmount = nil
    lowestAmount = nil
  }

  mutating func resetAmountFilter() {
    highestAmount = nil
    lowestAmount = nil
  }
}

// MARK: - LedgerFilterItemProperty

struct LedgerFilterItemProperty: Equatable, Identifiable, Hashable {
  /// 친구 아이디
  var id: Int64
  /// 친구 이름
  var title: String
}
