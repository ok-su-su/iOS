//
//  CreateEnvelopeRelationItemProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork
import SSSelectableItems

// MARK: - CreateEnvelopeRelationItemPropertyHelper

struct CreateEnvelopeRelationItemPropertyHelper: Equatable {
  var selectedID: [Int] = []
  var defaultRelations: [CreateEnvelopeRelationItemProperty] = []
  var customRelation: CreateEnvelopeRelationItemProperty? = nil

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
    let customItem = items.first(where: { $0.isCustom == true })
    let currentItems = items.filter { $0.isCustom == false }
    defaultRelations = currentItems
    customRelation = customItem
  }

  init() {}
}

// MARK: - CreateEnvelopeRelationItemProperty

public typealias CreateEnvelopeRelationItemProperty = RelationshipModel

// MARK: SSSelectableItemable

extension CreateEnvelopeRelationItemProperty: SSSelectableItemable {
  public var title: String {
    get { relation }
    set { relation = newValue }
  }
}
