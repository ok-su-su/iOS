//
//  SearchEnvelopeResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct SearchEnvelopeResponse: Codable, Equatable {
  public let envelope: EnvelopeModel
  public let category: CategoryWithCustomModel?
  public let friend: FriendModel?
  public let relationship: RelationshipModel?
  public let friendRelationship: FriendRelationshipModel?

  enum CodingKeys: String, CodingKey {
    case envelope
    case category
    case friend
    case relationship
    case friendRelationship
  }
}
