//
//  PageResponseDtoSearchFriendResponse.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PageResponseDtoSearchFriendResponse

struct PageResponseDtoSearchFriendResponse: Codable {
  let data: [SearchFriendResponse]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortObject

  enum CodingKeys: CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}

// MARK: - SearchFriendResponse

struct SearchFriendResponse: Codable {
  let friend: FriendModel
  let relationship: RelationshipInfoModel
  let recentEnvelope: RecentEnvelopeModel?
  enum CodingKeys: CodingKey {
    case friend
    case relationship
    case recentEnvelope
  }
}

// MARK: - FriendModel

struct FriendModel: Codable {
  let id: Int64
  let name, phoneNumber: String
  enum CodingKeys: CodingKey {
    case id
    case name
    case phoneNumber
  }
}

// MARK: - RecentEnvelopeModel

struct RecentEnvelopeModel: Codable {
  let category, handedOverAt: String
  enum CodingKeys: CodingKey {
    case category
    case handedOverAt
  }
}

// MARK: - RelationshipInfoModel

struct RelationshipInfoModel: Codable {
  let id: Int
  let relation: String
  let customRelation: String?
  let description: String?
  enum CodingKeys: CodingKey {
    case id
    case relation
    case customRelation
    case description
  }
}

// MARK: - SortObject

struct SortObject: Codable {
  let empty, unsorted, sorted: Bool
  enum CodingKeys: CodingKey {
    case empty
    case unsorted
    case sorted
  }
}
