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
    return selectedID.filter { $0 != 1024 }.first
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
