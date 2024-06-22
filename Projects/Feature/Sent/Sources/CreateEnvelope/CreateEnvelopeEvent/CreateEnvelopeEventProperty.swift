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
  private var defaultEventStrings: [String] = []
  var defaultEvent: [CreateEnvelopeEventProperty] = []

  var customEvent: CreateEnvelopeEventProperty? = nil

  func getSelectedItemID() -> Int? {
    selectedID.first
  }

  func getSelectedCustomItemName() -> String? {
    if selectedID.first == customEvent?.id {
      return customEvent?.title
    }
    return nil
  }

  /// 마지막에는 기타 Item이 와야 합니다. 기타 Item을 자동으로 없애줍니다.
  mutating func updateItems(_ items: [CreateEnvelopeEventProperty]) {
    var items = items
    _ = items.popLast()
    // TODO: API로직 바꿔달라고 말 하기
    defaultEvent = items
    customEvent = .init(id: items.count, title: "")
  }

  init() {}
}
