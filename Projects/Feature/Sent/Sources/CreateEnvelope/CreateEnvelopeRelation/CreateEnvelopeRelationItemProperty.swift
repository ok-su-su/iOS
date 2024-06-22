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
  var defaultRelations: [CreateEnvelopeRelationItemProperty] = [
    .init(id: 1, title: "친구"),
    .init(id: 2, title: "가족"),
    .init(id: 3, title: "친적"),
    .init(id: 4, title: "동료"),
    .init(id: 5, title: "직장"),
  ]

  var customRelation: CreateEnvelopeRelationItemProperty? = .init(id: 6, title: "")

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
