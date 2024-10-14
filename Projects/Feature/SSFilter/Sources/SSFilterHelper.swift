//
//  SSFilterHelper.swift
//  SSFilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import CommonExtension
import Foundation
import SSLayout

// MARK: - SSFilterItemHelper

public struct SSFilterItemHelper<Item: SSFilterItemable>: Equatable, Sendable {
  var selectableItems: [Item]
  var selectedItems: [Item]

  mutating func select(_ id: Item.ID) {
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

  mutating func reset() {
    selectedItems = []
  }
}

// MARK: - SSFilterItemable

public protocol SSFilterItemable: Equatable, Sendable, Identifiable, Hashable where ID == Int64 {
  var id: Int64 { get }
  var title: String { get set }
}
