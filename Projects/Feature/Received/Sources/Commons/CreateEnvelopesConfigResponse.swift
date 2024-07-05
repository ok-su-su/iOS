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
