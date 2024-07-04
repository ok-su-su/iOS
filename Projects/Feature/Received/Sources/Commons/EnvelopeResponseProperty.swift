//
//  EnvelopeResponseProperty.swift
//  Received
//
//  Created by MaraMincho on 7/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation


struct   EnvelopeModel: Codable, Equatable {
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


// MARK: - SearchFriendsFriendResponseDTO

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


// MARK: - SearchEnvelopeResponseFriendRelationshipDTO

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
