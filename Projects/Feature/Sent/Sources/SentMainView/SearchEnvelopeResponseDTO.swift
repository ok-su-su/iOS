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

struct SearchFriendsResponseDataDTO: Codable, Equatable {
  let friend: SearchFriendsFriendResponseDTO
  let totalAmounts: Int
  let sentAmounts: Int
  let receivedAmounts: Int

  enum CodingKeys: String, CodingKey {
    case friend
    case totalAmounts
    case sentAmounts
    case receivedAmounts
  }
}

// MARK: - SearchFriendsFriendResponseDTO

struct SearchFriendsFriendResponseDTO: Codable, Equatable {
  let id: Int
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
  let id: Int
  let seq: Int
  let category: String
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
  let id: Int
  /// user id, 소유자
  let uid: Int
  /// Sent or RECIVED
  let type: String
  /// 금액
  let amount: Int
  /// 선물
  let gift: String
  /// 메모
  let memo: String
  /// 방문여부
  let hasVisited: Bool
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
  let id: Int
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
  let id: Int
  let friendID: Int
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

// MARK: - SortResponseDTO

struct SortResponseDTO: Codable, Equatable {
  ///
  let empty: Bool?
  let sorted: Bool?
  let unsorted: Bool?

  enum CodingKeys: String, CodingKey {
    case empty
    case sorted
    case unsorted
  }
}
