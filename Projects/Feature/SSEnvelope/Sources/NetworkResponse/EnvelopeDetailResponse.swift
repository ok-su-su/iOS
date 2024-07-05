//
//  EnvelopeDetailResponse.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct EnvelopeDetailResponse: Decodable {
  let envelope: EnvelopeModel
  let category: CategoryWithCustomModel
  let relationship: RelationshipModel
  let friendRelationship: FriendRelationshipModel
  let friend: FriendModel
  enum CodingKeys: CodingKey {
    case envelope
    case category
    case relationship
    case friendRelationship
    case friend
  }
}
