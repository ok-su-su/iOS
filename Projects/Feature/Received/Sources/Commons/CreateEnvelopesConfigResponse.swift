//
//  CreateEnvelopesConfigResponse.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopesConfigResponse

struct CreateEnvelopesConfigResponse: Decodable {
  var categories: [CategoryModel]
  var relationships: [RelationshipModel]
  enum CodingKeys: CodingKey {
    case categories
    case relationships
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

// MARK: - CategoryModel

struct CategoryModel: Codable, Equatable {
  /// 카테고리 아이디
  let id: Int
  /// 카테고리 순서
  let seq: Int
  /// 카테고리 이름
  let name: String
  /// 카테고리 스타일
  let style: String
  /// 기타
  let isMiscCategory: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case seq
    case name
    case style
    case isMiscCategory
  }
}
