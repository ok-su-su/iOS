//
//  PageResponseDtoSearchEnvelopeResponse.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PageResponseDtoSearchEnvelopeResponse

struct PageResponseDtoSearchEnvelopeResponse: Decodable {
  let data: [SearchLatestOfThreeEnvelopeDataResponseDTO]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortObject
}

// MARK: - SearchLatestOfThreeEnvelopeDataResponseDTO

struct SearchLatestOfThreeEnvelopeDataResponseDTO: Decodable {
  let envelope: EnvelopeModel
  let category: CategoryWithCustomModel?
  let relationship: RelationshipModel?
  let friend: FriendModel?
  let friendRelationship: FriendRelationshipModel?
}

// MARK: - EnvelopeModel

struct EnvelopeModel: Codable, Equatable {
  ///  봉투 id
  let id: Int64
  /// user id, 소유자
  let uid: Int64
  /// Sent or RECIVED
  let type: String
  /// 금액
  let amount: Int64
  /// 선물
  let gift: String?
  /// 메모
  let memo: String?
  /// 방문여부
  let hasVisited: Bool?
  /// 전달 일
  let handedOverAt: String

  enum CodingKeys: String, CodingKey {
    case id
    case uid
    case type
    case amount
    case gift
    case memo
    case hasVisited
    case handedOverAt
  }
}

// MARK: - CategoryWithCustomModel

struct CategoryWithCustomModel: Codable {
  /// 카테고리 아이디
  let id: Int64
  /// 카테고리 순서
  let seq: Int
  /// 카테고리 이름
  let category: String
  /// 커스텀 카테고리 이름
  let customCategory: String?
  /// 카테고리 스타일
  let style: String

  enum CodingKeys: CodingKey {
    case id
    case seq
    case category
    case customCategory
    case style
  }
}

// MARK: - RelationshipModel

struct RelationshipModel: Codable, Equatable {
  /// 관계 ID
  let id: Int
  /// 관계 이름
  let relation: String
  /// 관계 설명
  let description: String?

  enum CodingKeys: String, CodingKey {
    case id
    case relation
    case description
  }
}

// MARK: - FriendModel

struct FriendModel: Codable, Equatable {
  let id: Int64
  let name: String
  let phoneNumber: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case phoneNumber
  }
}

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

// MARK: - SortObject

struct SortObject: Equatable, Codable {
  let empty, unsorted, sorted: Bool?
}
