//
//  CreateEnvelopesConfigResponse.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopesConfigResponse

public struct CreateEnvelopesConfigResponse: Decodable {
  public var categories: [CategoryModel]
  public var relationships: [RelationshipModel]
  enum CodingKeys: CodingKey {
    case categories
    case relationships
  }
}
