//
//  RelationshipModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchEnvelopeResponseRelationshipDTO

public struct RelationshipModel: Codable, Equatable, Identifiable, Sendable {
  /// 관계 ID
  public let id: Int
  /// 관계 이름
  public var relation: String
  /// 관계 설명
  public let description: String?
  /// 커스텀 모델의 여부
  public let isCustom: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case relation
    case description
    case isCustom
  }

  public init(id: Int, relation: String, description: String?, isCustom: Bool) {
    self.id = id
    self.relation = relation
    self.description = description
    self.isCustom = isCustom
  }
}
