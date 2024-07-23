//
//  SearchEnvelopeResponseDTO.swift
//  Sent
//
//  Created by MaraMincho on 6/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchEnvelopeResponseDTO = try? JSONDecoder().decode(SearchEnvelopeResponseDTO.self, from: jsonData)

import Foundation

// MARK: - SearchFriendsResponseDTO

struct SearchFriendsResponseDTO: Codable, Equatable {
  let data: [SearchFriendsResponseDataDTO]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortResponseDTO

  enum CodingKeys: String, CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}

// MARK: - SearchFriendsResponseDataDTO

/// 친구 검색 화면에 사용되는 ResponseDTO입니다. 친구가 누가 있는지 그리고 검색을 위해 활용됩니다.
struct SearchFriendsResponseDataDTO: Codable, Equatable {
  let friend: SearchFriendsFriendResponseDTO
  let totalAmounts: Int64
  let sentAmounts: Int64
  let receivedAmounts: Int64

  enum CodingKeys: CodingKey {
    case friend
    case totalAmounts
    case sentAmounts
    case receivedAmounts
  }
}

// MARK: - SearchFriendsFriendResponseDTO

struct SearchFriendsFriendResponseDTO: Codable, Equatable {
  let id: Int64
  let name: String
  let phoneNumber: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case phoneNumber
  }
}

// MARK: - SearchEnvelopeResponseDTO

struct SearchEnvelopeResponseDTO: Codable, Equatable {
  let data: [SearchEnvelopeResponseDataDTO]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortResponseDTO

  enum CodingKeys: String, CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}

// MARK: - SearchEnvelopeResponseDTOWithOptional

struct SearchEnvelopeResponseDTOWithOptional: Codable, Equatable {
  let data: [SearchEnvelopeResponseDataDTOWithOptional]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortResponseDTO

  enum CodingKeys: String, CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}

// MARK: - SearchEnvelopeResponseDataDTOWithOptional

struct SearchEnvelopeResponseDataDTOWithOptional: Codable, Equatable {
  let envelope: SearchEnvelopeResponseEnvelopeDTO
  let category: SearchEnvelopeResponseCategoryDTO?
  let friend: SearchEnvelopeResponseFriendDTO?
  let relationship: SearchEnvelopeResponseRelationshipDTO?
  let friendRelationship: SearchEnvelopeResponseFriendRelationshipDTO?

  enum CodingKeys: String, CodingKey {
    case envelope
    case category
    case friend
    case relationship
    case friendRelationship
  }
}

// MARK: - SearchEnvelopeResponseDataDTO

struct SearchEnvelopeResponseDataDTO: Codable, Equatable {
  let envelope: SearchEnvelopeResponseEnvelopeDTO
  let category: SearchEnvelopeResponseCategoryDTO
  let friend: SearchEnvelopeResponseFriendDTO
  let relationship: SearchEnvelopeResponseRelationshipDTO
  let friendRelationship: SearchEnvelopeResponseFriendRelationshipDTO

  enum CodingKeys: String, CodingKey {
    case envelope
    case category
    case friend
    case relationship
    case friendRelationship
  }
}

// MARK: - SearchEnvelopeResponseCategoryDTO

struct SearchEnvelopeResponseCategoryDTO: Codable, Equatable {
  /// 카테고리 아이디
  let id: Int
  ///
  let seq: Int
  /// 카테고리 이름
  let category: String
  /// 커스텀 카테고리면 not nill
  let customCategory: String?
  let style: String?

  enum CodingKeys: String, CodingKey {
    case id
    case seq
    case category
    case customCategory
    case style
  }
}

// MARK: - SearchEnvelopeResponseEnvelopeDTO

struct SearchEnvelopeResponseEnvelopeDTO: Codable, Equatable {
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

// MARK: - SearchEnvelopeResponseFriendDTO

struct SearchEnvelopeResponseFriendDTO: Codable, Equatable {
  /// 지인 ID
  let id: Int64
  /// 지인 이름
  let name: String
  /// 지인 전화번호
  let phoneNumber: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case phoneNumber
  }
}

// MARK: - SearchEnvelopeResponseFriendRelationshipDTO

struct SearchEnvelopeResponseFriendRelationshipDTO: Codable, Equatable {
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

// MARK: - SearchEnvelopeResponseRelationshipDTO

struct SearchEnvelopeResponseRelationshipDTO: Codable, Equatable {
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
