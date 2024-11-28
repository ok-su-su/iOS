//
//  CreateEnvelopeRelationItemProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton
import SSNetwork
import SSSelectableItems

public struct CreateEnvelopeRelationItemProperty: Codable, Equatable, Identifiable, Sendable, SingleSelectButtonItemable {
  public var title: String {
    get { relation }
    set { relation = newValue }
  }

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

  public init(_ relationshipModel: RelationshipModel) {
    id = relationshipModel.id
    relation = relationshipModel.relation
    description = relationshipModel.description
    isCustom = relationshipModel.isCustom
  }

  public init(id: Int, relation: String, description: String?, isCustom: Bool) {
    self.id = id
    self.relation = relation
    self.description = description
    self.isCustom = isCustom
  }
}
