//
//  VisitedSelectButtonItem.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton

// MARK: - VisitedEditProperty

struct VisitedEditProperty: Equatable, EnvelopeEditPropertiable {
  let originalVisited: Bool?
  var isVisited: Bool?

  init(isVisited: Bool?) {
    self.isVisited = isVisited
    originalVisited = isVisited
  }

  var isValid: Bool {
    return true
  }

  var isChanged: Bool {
    originalVisited != isVisited
  }
}

// MARK: - VisitedSelectButtonItem

public struct VisitedSelectButtonItem: SingleSelectButtonItemable {
  public var id: Int
  public var title: String = ""
  var isVisited: Bool
  init(id: Int, title: String = "", isVisited: Bool) {
    self.id = id
    self.title = title
    self.isVisited = isVisited
  }

  mutating func setTitle(by isVisited: Bool) {
    title = isVisited ? "예" : "아니오"
  }
}

extension VisitedSelectButtonItem {
  static func defaultItems() -> [Self] {
    return [
      yes, no,
    ]
  }

  static var yes: Self {
    .init(id: 0, title: "예", isVisited: true)
  }

  static var no: Self {
    .init(id: 1, title: "아니오", isVisited: false)
  }
}
