//
//  CreateEnvelopeCategoryProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSSelectableItems

// MARK: - CreateEnvelopeCategoryProperty

public struct CreateEnvelopeCategoryProperty: Equatable, Identifiable, SSSelectableItemable {
  public var id: Int
  public var title: String

  public mutating func setTitle(_ val: String) {
    title = val
  }

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

// MARK: - CreateEnvelopeCategoryPropertyHelper

struct CreateEnvelopeCategoryPropertyHelper: Equatable {
  var selectedID: [Int] = []
  private var defaultEventStrings: [String] = []
  var defaultEvent: [CreateEnvelopeCategoryProperty] = []

  var customEvent: CreateEnvelopeCategoryProperty? = nil

  func getSelectedItemID() -> Int? {
    selectedID.first
  }

  func getSelectedItemName() -> String? {
    guard let selectedID = selectedID.first else {
      return nil
    }
    guard let selectedItem = defaultEvent.first(where: { $0.id == selectedID }) else {
      return "기타"
    }
    return selectedItem.title
  }

  mutating func resetSelectedItems() {
    selectedID.removeAll()
  }

  func getSelectedCustomItemName() -> String? {
    if selectedID.first == customEvent?.id {
      return customEvent?.title
    }
    return nil
  }

  /// 마지막에는 기타 Item이 와야 합니다. 기타 Item을 자동으로 없애줍니다.
  mutating func updateItems(_ items: [CreateEnvelopeCategoryProperty]) {
    var items = items
    guard let customItemID = items.popLast()?.id else {
      return
    }

    // TODO: API로직 바꿔달라고 말 하기
    defaultEvent = items
    customEvent = .init(id: customItemID, title: "")
  }

  init() {}
}
