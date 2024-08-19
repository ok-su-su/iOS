//
//  CreateEnvelopeRelationItemProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSSelectableItems

// MARK: - CreateEnvelopeRelationItemPropertyHelper

struct CreateEnvelopeRelationItemPropertyHelper: Equatable {
  var selectedID: [Int] = []
  var defaultRelations: [CreateEnvelopeRelationItemProperty] = []
  var customRelation: CreateEnvelopeRelationItemProperty? = .init(id: 1024, title: "")

  mutating func resetSelectedItems() {
    selectedID.removeAll()
  }

  /// 선택된 items 중 사용자가 입력하지 않은 ID를 리턴합니다.
  func getSelectedID() -> Int? {
    return selectedID.first
  }

  func getSelectedCustomItemName() -> String? {
    if selectedID.first == customRelation?.id {
      return customRelation?.title
    }
    return nil
  }

  /// 마지막에 기타 아이템이 와야 합니다. 기타 아이템을 없앱니다.
  mutating func updateItems(_ items: [CreateEnvelopeRelationItemProperty]) {
    var items = items
    guard let customItemID = items.popLast()?.id else {
      return
    }
    defaultRelations = items
    customRelation = .init(id: customItemID, title: "")
  }

  init() {}
}

// MARK: - CreateEnvelopeRelationItemProperty

public struct CreateEnvelopeRelationItemProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  public var id: Int
  public var title: String

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }

  public mutating func setTitle(_ val: String) {
    title = val
  }
}
