//
//  SingleSelectButtonItemable.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SingleSelectButtonItemable

public protocol SingleSelectButtonItemable: Identifiable, Equatable {
  var id: Int { get set }
  var title: String { get set }
}

// MARK: - SingleSelectButtonHelper

struct SingleSelectButtonHelper<Item: SingleSelectButtonItemable>: Equatable {
  var titleText: String
  var items: [Item]
  var selectedItem: Item?
  var isCustomItem: Item?
  var isStartedAddingNewCustomItem = false
  var customTextFieldPrompt: String?
  var isSaved: Bool = false
  var isEssentialProperty = true

  var allItems: [Item] {
    return (items + [isCustomItem]).compactMap { $0 }
  }

  init(titleText: String, items: [Item], isCustomItem: Item?, customTextFieldPrompt: String?, isEssentialProperty: Bool = true) {
    self.titleText = titleText
    self.items = items
    self.isCustomItem = isCustomItem
    self.customTextFieldPrompt = customTextFieldPrompt
    self.isEssentialProperty = isEssentialProperty
  }

  mutating func selectItem(by id: Int) {
    if let firstItemIndex = items.firstIndex(where: { $0.id == id }) {
      if isEssentialProperty == false && selectedItem == items[firstItemIndex] {
        selectedItem = nil
      }
      selectedItem = items[firstItemIndex]
    }
  }

  mutating func makeAndSelectedCustomItem(title: String) {
    selectedItem?.title = title
    selectedItem = isCustomItem
  }

  mutating func selectedCustomItem() {
    selectedItem = isCustomItem
  }

  mutating func editCustomSection() {
    selectedItem = nil
    isStartedAddingNewCustomItem = true
    isSaved = false
  }

  mutating func startAddCustomSection() {
    selectedItem = nil
    isStartedAddingNewCustomItem = true
    isCustomItem?.title = ""
    isSaved = false
  }

  mutating func resetCustomTextField() {
    isCustomItem?.title = ""
    isSaved = false
    isStartedAddingNewCustomItem = false
  }

  mutating func saveCustomTextField(title: String) {
    selectedItem = nil
    isStartedAddingNewCustomItem = false
    isCustomItem?.title = title
    isSaved = true
  }

  func isValid() -> Bool {
    if isEssentialProperty == false {
      return true
    }else {
      return selectedItem != nil
    }
  }
}
