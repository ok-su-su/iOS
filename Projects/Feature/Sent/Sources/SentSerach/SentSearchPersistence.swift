//
//  SentSearchPersistence.swift
//  Sent
//
//  Created by MaraMincho on 6/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import SSPersistancy

// MARK: - SentSearchPersistence

struct SentSearchPersistence {
  func getPrevSentSearchItems() -> [SentSearchItem] {
    guard let value = SSUserDefaultsManager.shared.getValue(key: key) as? String else {
      return []
    }
    return value
      .split(separator: ",")
      .map { String($0) }
      .enumerated()
      .map { .init(id: Int64($0.offset), title: $0.element) }
  }

  func setSearchItems(_ item: SentSearchItem) {
    let value = (SSUserDefaultsManager.shared.getValue(key: key) as? String) ?? ""
    let setValue = item.title + "," + value
    SSUserDefaultsManager.shared.setValue(key: key, value: setValue)
  }

  private let key: String = .init(describing: SentSearchItem.self).description
}

// MARK: DependencyKey

extension SentSearchPersistence: DependencyKey {
  static var liveValue: SentSearchPersistence = .init()
}

extension DependencyValues {
  var sentSearchPersistence: SentSearchPersistence {
    get { self[SentSearchPersistence.self] }
    set { self[SentSearchPersistence.self] = newValue }
  }
}
