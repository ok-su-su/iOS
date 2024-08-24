//
//  VoteSearchPersistence.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import CommonExtension
import SSPersistancy

final class VoteSearchPersistence {

  private init() {}

  static func getPrevVoteSearchItems() -> [VoteSearchItem] {
    return SSUserDefaultsManager.shared.getValue(key: key) ?? []
  }

  private static func savePrevVoteSearchItems(_ item: [VoteSearchItem]) {
    SSUserDefaultsManager.shared.setValue(key: key, value: item.uniqued())
  }

  static func setPrevVoteSearchItems(_ item: VoteSearchItem) {
    let prevItems = getPrevVoteSearchItems()
    let uniqueItems = ([item] + prevItems).uniqued()
    savePrevVoteSearchItems(uniqueItems)
  }

  private static let key: String = .init(describing: VoteSearchPersistence.self).description
}
