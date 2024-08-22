//
//  RelationshipInfoModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - RelationshipInfoModel

public struct RelationshipInfoModel: Equatable, Codable {
  public let id: Int
  public let relation: String
  public let customRelation: String?
  public let description: String?
  enum CodingKeys: CodingKey {
    case id
    case relation
    case customRelation
    case description
  }
}
