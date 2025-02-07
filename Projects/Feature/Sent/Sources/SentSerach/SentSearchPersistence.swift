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
    return SSUserDefaultsManager.shared.getValue(key: key) ?? []
  }

  func setSearchItems(_ item: SentSearchItem?) {
    guard let item else { return }
    let prevItems: [SentSearchItem] = SSUserDefaultsManager.shared.getValue(key: key) ?? []
    let uniqueSetItems = Array((prevItems + [item]).uniqued().prefix(5))
    setItems(uniqueSetItems)
  }

  private func setItems(_ items: [SentSearchItem]) {
    SSUserDefaultsManager.shared.setValue(key: key, value: items)
  }

  func deleteSearchItem(id: Int64) {
    let items = getPrevSentSearchItems().filter { $0.id != id }
    setItems(items)
  }

  private let key: String = .init(describing: SentSearchItem.self).description
}

// MARK: DependencyKey

extension SentSearchPersistence: DependencyKey {
  static let liveValue: SentSearchPersistence = .init()
}

extension DependencyValues {
  var sentSearchPersistence: SentSearchPersistence {
    get { self[SentSearchPersistence.self] }
    set { self[SentSearchPersistence.self] = newValue }
  }
}
