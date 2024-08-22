//
//  SearchFriendResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchFriendResponse

public struct SearchFriendResponse: Equatable, Codable {
  public let friend: FriendModel
  public let relationship: RelationshipInfoModel
  public let recentEnvelope: RecentEnvelopeModel?
  enum CodingKeys: CodingKey {
    case friend
    case relationship
    case recentEnvelope
  }
}
