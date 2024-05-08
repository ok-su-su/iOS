//
//  CreateEnvelopeRelationItemProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeRelationItemProperty

struct CreateEnvelopeRelationItemProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  let id: UUID
  var title: String

  init(id: UUID, title: String) {
    self.id = id
    self.title = title
  }

  mutating func setTitle(_ val: String) {
    title = val
  }
}

// MARK: - CreateEnvelopeRelationItemPropertyAdapter

struct CreateEnvelopeRelationItemPropertyAdapter: Equatable {
  var selectedID: [UUID] = []
  var defaultRelations: [CreateEnvelopeRelationItemProperty] = [
    .init(id: UUID(1), title: "친구"),
    .init(id: UUID(2), title: "가족"),
    .init(id: UUID(3), title: "친적"),
    .init(id: UUID(4), title: "동료"),
    .init(id: UUID(5), title: "직장"),
  ]

  var customRelation: CreateEnvelopeRelationItemProperty? = .init(id: UUID(6), title: "")

  init() {}
}
