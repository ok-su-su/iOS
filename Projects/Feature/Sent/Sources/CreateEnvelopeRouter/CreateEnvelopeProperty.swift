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
  var viewDepth = 1
  var additionalSectionHelper: CreateEnvelopeAdditionalSectionHelper = .init()
  var relationHelper: CreateEnvelopeRelationItemPropertyHelper = .init()
  var eventHelper: CreateEnvelopeEventPropertyHelper = .init()
  init() {}

  var prevNames: [PrevEnvelope] = [
    .init(name: "김철수", relationShip: "친구", eventName: "결혼식", eventDate: .now),
    .init(name: "김철수", relationShip: "친구", eventName: "결혼식", eventDate: .now),
    .init(name: "김채원", relationShip: "동료", eventName: "결혼식", eventDate: .now),
    .init(name: "김채소", relationShip: "동창", eventName: "결혼식", eventDate: .now),
  ]

  var customRelation: [String] = [
    "동창",
  ]

  // TODO: - change Names
  func filteredName(_ value: String) -> [PrevEnvelope] {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(value)[\\w\\p{L}]*") else {
      return []
    }
    return prevNames.filter { $0.name.contains(regex) }
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
