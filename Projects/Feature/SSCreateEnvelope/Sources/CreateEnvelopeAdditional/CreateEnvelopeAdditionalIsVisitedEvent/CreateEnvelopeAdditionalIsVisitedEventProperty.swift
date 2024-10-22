//
//  CreateEnvelopeAdditionalIsVisitedEventProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSSelectableItems

// MARK: - CreateEnvelopeAdditionalIsVisitedEventProperty

public struct CreateEnvelopeAdditionalIsVisitedEventProperty: Equatable, Identifiable, SSSelectableItemable, Sendable {
  public var id: Int

  public var title: String
  public mutating func setTitle(_: String) {
    return
  }
}

// MARK: - CreateEnvelopeAdditionalIsVisitedEventHelper

public struct CreateEnvelopeAdditionalIsVisitedEventHelper: Equatable, Sendable {
  var items: [CreateEnvelopeAdditionalIsVisitedEventProperty] = [
    .init(id: 0, title: "예"),
    .init(id: 1, title: "아니오"),
  ]
  var selectedID: [Int] = []

  mutating func reset() {
    selectedID.removeAll()
  }

  var isVisited: Bool { return selectedID.first == 0 }
}
