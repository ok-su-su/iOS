//
//  CreateEnvelopesConfigResponse.swift
//  Statistics
//
//  Created by MaraMincho on 8/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopesConfigResponse

struct CreateEnvelopesConfigResponse: Codable, Equatable {
  let categories: [CategoryModel]
  let relationships: [RelationshipModel]

  enum CodingKeys: String, CodingKey {
    case categories
    case relationships
  }
}

// MARK: - CategoryModel

struct CategoryModel: Codable, Equatable {
  let id: Int
  let seq: Int
  let name: String
  let style: String
  let isMiscCategory: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case seq
    case name
    case style
    case isMiscCategory
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
