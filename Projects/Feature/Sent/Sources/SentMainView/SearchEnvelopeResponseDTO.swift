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
