//
//  TitleAndItemsWithSingleSellectButtonProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

protocol SingeSelectButtonItemable :Identifiable, Equatable  {
  var id: UUID { get set}
  var title : String { get set}
}


struct SingleSelectButtonHelper<Item: SingeSelectButtonItemable>: Equatable {
  var titleText: String
  var items: [Item]
  var selectedItem: Item?
  var isCustomItem: Item?
  var isStartedAddingNewCustomItem = false
  var customTextFieldPrompt: String?
  var isSaved: Bool = false
  
  init(titleText: String, items: [Item], isCustomItem: Item?, customTextFieldPrompt: String?) {
    self.titleText = titleText
    self.items = items
    self.isCustomItem = isCustomItem
    self.customTextFieldPrompt = customTextFieldPrompt
  }
  
  mutating func selectItem(by id: UUID) {
    if let firstItemIndex = items.firstIndex(where: {$0.id == id}) {
      selectedItem = items[firstItemIndex]
    }
  }
  
  mutating func startAddCustomSection() {
    isStartedAddingNewCustomItem = true
  }
  
  mutating func resetCustomTextField() {
    isCustomItem?.title = ""
    isSaved = false
  }
  mutating func saveCustomTextField() {
    isSaved = true
  }
}
