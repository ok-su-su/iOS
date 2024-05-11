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
  
  init(titleText: String, items: [Item]) {
    self.titleText = titleText
    self.items = items
  }
  
  mutating func selectItem(by id: UUID) {
    if let firstItemIndex = items.firstIndex(where: {$0.id == id}) {
      selectedItem = items[firstItemIndex]
    }
  }
}
