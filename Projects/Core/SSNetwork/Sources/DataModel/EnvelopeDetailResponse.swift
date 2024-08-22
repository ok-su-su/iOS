//
//  EnvelopeDetailResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct EnvelopeDetailResponse: Decodable {
  public let envelope: EnvelopeModel
  public let category: CategoryWithCustomModel
  public let relationship: RelationshipModel
  public let friendRelationship: FriendRelationshipModel
  public let friend: FriendModel
  enum CodingKeys: CodingKey {
    case envelope
    case category
    case relationship
    case friendRelationship
    case friend
  }
}
