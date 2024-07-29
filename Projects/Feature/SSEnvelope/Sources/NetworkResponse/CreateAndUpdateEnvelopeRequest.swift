//
//  CreateAndUpdateEnvelopeRequest.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateAndUpdateEnvelopeResponse

struct CreateAndUpdateEnvelopeResponse: Decodable {
  var envelope: EnvelopeModel
  var friend: FriendModel
  var friendRelationship: FriendRelationshipModel
  var relationship: RelationshipModel
  var category: CategoryWithCustomModel

  enum CodingKeys: CodingKey {
    case envelope
    case friend
    case friendRelationship
    case relationship
    case category
  }
}

// MARK: - CreateAndUpdateEnvelopeRequest

struct CreateAndUpdateEnvelopeRequest: Encodable {
  let type: String
  let friendId: Int64
  let ledgerId: Int64?
  let amount: Int64
  let gift: String?
  let memo: String?
  let hasVisited: Bool?
  let handedOverAt: String
  let category: CreateCategoryAssignmentRequest?

  enum CodingKeys: CodingKey {
    case type
    case friendId
    case ledgerId
    case amount
    case gift
    case memo
    case hasVisited
    case handedOverAt
    case category
  }
}

// MARK: - CreateCategoryAssignmentRequest

struct CreateCategoryAssignmentRequest: Encodable {
  let id: Int
  let customCategory: String?
  enum CodingKeys: CodingKey {
    case id
    case customCategory
  }
}
