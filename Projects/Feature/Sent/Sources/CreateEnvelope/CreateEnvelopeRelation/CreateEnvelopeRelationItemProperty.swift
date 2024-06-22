//
//  CreateEnvelopeRelationItemProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeRelationItemPropertyHelper

struct CreateEnvelopeRelationItemPropertyHelper: Equatable {
  var selectedID: [Int] = []
  var defaultRelations: [CreateEnvelopeRelationItemProperty] = []
  var customRelation: CreateEnvelopeRelationItemProperty? = .init(id: 1024, title: "")

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
    _ = items.popLast()
    defaultRelations = items
    customRelation = .init(id: items.count, title: "")
  }

  init() {}
}

// MARK: - CreateEnvelopeRelationItemProperty

struct CreateEnvelopeRelationItemProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  let id: Int
  var title: String

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }

  mutating func setTitle(_ val: String) {
    title = val
  }
}
