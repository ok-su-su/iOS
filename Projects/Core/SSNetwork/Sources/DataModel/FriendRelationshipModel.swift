//
//  FriendRelationshipModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct FriendRelationshipModel: Codable, Equatable {
  /// 지인 ID
  public let id: Int64
  /// 지인 ID
  public let friendID: Int64
  /// 관계 ID
  public let relationshipID: Int
  /// CustomRelation Name
  public let customRelation: String?

  enum CodingKeys: String, CodingKey {
    case id
    case friendID = "friendId"
    case relationshipID = "relationshipId"
    case customRelation
  }
}
