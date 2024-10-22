//
//  CreateEnvelopeProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeProperty

public struct CreateEnvelopeProperty: Equatable, Sendable {
  var additionalSectionHelper: CreateEnvelopeAdditionalSectionHelper = .init()
  var relationHelper: CreateEnvelopeRelationItemPropertyHelper = .init()
  var eventHelper: CreateEnvelopeCategoryPropertyHelper = .init()
  var isVisitedHelper: CreateEnvelopeAdditionalIsVisitedEventHelper = .init()
  var additionIsGiftHelper: CreateEnvelopeAdditionalIsGiftPropertyHelper = .init()
  var contactHelper: CreateEnvelopeAdditionalContactHelper = .init()
  var memoHelper: CreateEnvelopeAdditionalMemoHelper = .init()
  public init() {}

  /// 이름검색시 Filter되어 나타내는 봉투의 친구들을 나타내기 위해서 사용됩니다.
  var prevEnvelopes: [SearchFriendItem] = []

  func filteredName(_ value: String) -> [SearchFriendItem] {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(value)[\\w\\p{L}]*") else {
      return []
    }
    return prevEnvelopes.filter { $0.name.contains(regex) }
  }
}

// MARK: - SearchFriendItem

public struct SearchFriendItem: Equatable, Hashable, Sendable {
  let name: String
  let relationShip: String
  let eventName: String?
  let eventDate: Date?
}
