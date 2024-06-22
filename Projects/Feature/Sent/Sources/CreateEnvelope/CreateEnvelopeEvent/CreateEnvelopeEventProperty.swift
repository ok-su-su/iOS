//
//  CreateEnvelopeEventProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeEventProperty

struct CreateEnvelopeEventProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  var id: Int
  var title: String

  mutating func setTitle(_ val: String) {
    title = val
  }

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

// MARK: - CreateEnvelopeEventPropertyHelper

struct CreateEnvelopeEventPropertyHelper: Equatable {
  var selectedID: [Int] = []
  private var defaultEventStrings: [String] = [
    "결혼식",
    "돌잔치",
    "장례식",
    "생일기념일",
  ]
  var defaultEvent: [CreateEnvelopeEventProperty]

  var customEvent: CreateEnvelopeEventProperty?

  init() {
    defaultEvent = defaultEventStrings.enumerated().map { .init(id: Int($0.offset), title: $0.element) }
    customEvent = .init(id: Int(defaultEventStrings.count), title: "")
  }
}
