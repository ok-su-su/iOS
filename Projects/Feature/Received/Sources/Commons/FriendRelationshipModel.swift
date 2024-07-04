//
//  File.swift
//  Received
//
//  Created by MaraMincho on 7/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - FriendRelationshipModel

struct FriendRelationshipModel: Codable, Equatable {
  /// 지인 ID
  let id: Int64
  /// 지인 ID
  let friendID: Int64
  /// 관계 ID
  let relationshipID: Int
  let customRelation: String?

  enum CodingKeys: String, CodingKey {
    case id
    case friendID = "friendId"
    case relationshipID = "relationshipId"
    case customRelation
  }
}
