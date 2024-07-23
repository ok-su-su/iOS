//
//  CreateAndUpdateFriendRequest.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateAndUpdateFriendResponse

struct CreateAndUpdateFriendResponse: Decodable {
  let id: Int64

  enum CodingKeys: CodingKey {
    case id
  }
}

// MARK: - CreateAndUpdateFriendRequest

struct CreateAndUpdateFriendRequest: Encodable {
  let name: String
  let phoneNumber: String?
  let relationshipId: Int
  let customRelation: String?

  enum CodingKeys: CodingKey {
    case name
    case phoneNumber
    case relationshipId
    case customRelation
  }
}
