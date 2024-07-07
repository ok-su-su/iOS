//
//  SingleSelectButtonProperty.swift
//  SSEditSingleSelectButton
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct SingleSelectButtonProperty<Item: SingleSelectButtonItemable>: Equatable {
  /// 타이틀 텍스트 이릅입니다.
  public var titleText: String
  /// 커스텀 아이템을 제외한 아이템들을 보관합니다.
  public var items: [Item]
  /// selectedItem입니다.
  public var selectedItem: Item?
  // customItem입니다.
  public var isCustomItem: Item?
  public var isStartedAddingNewCustomItem = false
  public var customTextFieldPrompt: String?
  public var isSaved: Bool = false
  public var isEssentialProperty = true

  public var allItems: [Item] {
    return (items + [isCustomItem]).compactMap { $0 }
  }

  public init(titleText: String, items: [Item], isCustomItem: Item?, customTextFieldPrompt: String?, isEssentialProperty: Bool = true) {
    self.titleText = titleText
    self.items = items
    self.isCustomItem = isCustomItem
    self.customTextFieldPrompt = customTextFieldPrompt
    self.isEssentialProperty = isEssentialProperty
  }

  public mutating func updateCustomItem(_ item: Item) {
    isCustomItem = item
  }

  public mutating func selectItem(by id: Int) {
    if let firstItemIndex = items.firstIndex(where: { $0.id == id }) {
      if isEssentialProperty == false && selectedItem == items[firstItemIndex] {
        selectedItem = nil
      }
      selectedItem = items[firstItemIndex]
    }
  }

  public mutating func makeAndSelectedCustomItem(title: String) {
    selectedItem?.title = title
    selectedItem = isCustomItem
  }

  public mutating func selectedCustomItem() {
    selectedItem = isCustomItem
  }

  public mutating func editCustomSection() {
    selectedItem = nil
    isStartedAddingNewCustomItem = true
    isSaved = false
  }

  public mutating func startAddCustomSection() {
    selectedItem = nil
    isStartedAddingNewCustomItem = true
    isCustomItem?.title = ""
    isSaved = false
  }

  public mutating func resetCustomTextField() {
    isCustomItem?.title = ""
    isSaved = false
    isStartedAddingNewCustomItem = false
  }

  public mutating func saveCustomTextField(title: String) {
    selectedItem = nil
    isStartedAddingNewCustomItem = false
    isCustomItem?.title = title
    isSaved = true
  }

  public func isValid() -> Bool {
    if isEssentialProperty == false {
      return true
    } else {
      return selectedItem != nil
    }
  }
}