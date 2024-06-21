//
//  CreateFriendRequestBody.swift
//  Sent
//
//  Created by MaraMincho on 6/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct CreateFriendRequestBody: Codable, Equatable {
  var name: String? = nil
  var phoneNumber: String? = nil
  var relationshipId: Int? = nil
  var customRelation: String? = nil
  
  enum CodingKeys: CodingKey {
    case name
    case phoneNumber
    case relationshipId
    case customRelation
  }
}
