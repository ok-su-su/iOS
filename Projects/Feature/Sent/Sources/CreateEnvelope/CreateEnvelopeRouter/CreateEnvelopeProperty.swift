//
//  CreateEnvelopeProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeProperty

struct CreateEnvelopeProperty: Equatable {
  var additionalSectionHelper: CreateEnvelopeAdditionalSectionHelper = .init()
  var relationHelper: CreateEnvelopeRelationItemPropertyHelper = .init()
  var eventHelper: CreateEnvelopeEventPropertyHelper = .init()
  var isVisitedHelper: CreateEnvelopeAdditionalIsVisitedEventHelper = .init()
  var additionIsGiftHelper: CreateEnvelopeAdditionalIsGiftPropertyHelper = .init()
  var contactHelper: CreateEnvelopeAdditionalContactHelper = .init()
  var memoHelper: CreateEnvelopeAdditionalMemoHelper = .init()
  init() {}

  /// 이름검색시 Filter되어 나타내는 봉투의 친구들을 나타내기 위해서 사용됩니다.
  var prevEnvelopes: [PrevEnvelope] = []

  var customRelation: [String] = [
    "동창",
  ]

  // TODO: - change Names
  func filteredName(_ value: String) -> [PrevEnvelope] {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(value)[\\w\\p{L}]*") else {
      return []
    }
    return prevEnvelopes.filter { $0.name.contains(regex) }
  }
}

// MARK: - PrevEnvelope

// TODO: - change DTO
struct PrevEnvelope: Equatable {
  let name: String
  let relationShip: String
  let eventName: String
  let eventDate: Date
}
