//
//  RelationshipModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation


// MARK: - SearchEnvelopeResponseRelationshipDTO

public struct RelationshipModel: Codable, Equatable {
  /// 관계 ID
  public let id: Int
  /// 관계 이름
  public let relation: String
  /// 관계 설명
  public let description: String?

  enum CodingKeys: String, CodingKey {
    case id
    case relation
    case description
  }
}
