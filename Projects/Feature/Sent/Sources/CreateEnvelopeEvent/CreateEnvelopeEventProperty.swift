//
//  CreateEnvelope.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct CreateEnvelopeEventProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  var id: UUID
  var title: String
  
  mutating func setTitle(_ val: String) {
    self.title = val
  }
  
  init(id: UUID, title: String) {
    self.id = id
    self.title = title
  }
}


struct CreateEnvelopeEventPropertyHelper: Equatable {
  var selectedID: [UUID] = []
  private var defaultEventStrings: [String] = [
    "결혼식",
    "돌잔치",
    "장례식",
    "생일기념일",
  ]
  var defaultEvent: [CreateEnvelopeRelationItemProperty]

  var customRelation: CreateEnvelopeRelationItemProperty?

  init() {
    defaultEvent = defaultEventStrings.enumerated().map{.init(id: UUID($0.offset), title: $0.element)}
    customRelation = .init(id: UUID(defaultEventStrings.count), title: "")
  }
}
