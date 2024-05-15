//
//  CreateEnvelopeAdditionalIsVisitedEventProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeAdditionalIsVisitedEventProperty

struct CreateEnvelopeAdditionalIsVisitedEventProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  var id: UUID

  var title: String
  mutating func setTitle(_: String) {
    return
  }
}

// MARK: - CreateEnvelopeAdditionalIsVisitedEventHelper

struct CreateEnvelopeAdditionalIsVisitedEventHelper: Equatable {
  var items: [CreateEnvelopeAdditionalIsVisitedEventProperty] = [
    .init(id: UUID(0), title: "예"),
    .init(id: UUID(1), title: "아니오"),
  ]
  var selectedID: [UUID] = []
}
