//
//  RelationshipModel.swift
//  Received
//
//  Created by MaraMincho on 7/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

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
