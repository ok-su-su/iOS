//
//  ReceivedSearchPersistence.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import SSPersistancy

// MARK: - ReceivedSearchPersistence

struct ReceivedSearchPersistence {
  private init() {}
  func getPrevSearchItems() -> [ReceivedSearchItem] {
    return SSUserDefaultsManager.shared.getValue(key: Self.key) ?? []
  }

  func setSearchItems(_ item: ReceivedSearchItem?) {
    guard let item else {
      return
    }
    let newUniquedItems = Array((getPrevSearchItems() + [item]).uniqued().prefix(5))
    setPrevSearchItems(newUniquedItems)
  }

  private func setPrevSearchItems(_ items: [ReceivedSearchItem]) {
    SSUserDefaultsManager.shared.setValue(key: Self.key, value: items)
  }

  private static let key: String = .init(describing: [ReceivedSearchItem].self).description
}

// MARK: DependencyKey

extension ReceivedSearchPersistence: DependencyKey {
  static var liveValue: ReceivedSearchPersistence = .init()
}

extension DependencyValues {
  var receivedSearchPersistence: ReceivedSearchPersistence {
    get { self[ReceivedSearchPersistence.self] }
    set { self[ReceivedSearchPersistence.self] = newValue }
  }
}
