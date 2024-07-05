//
//  FriendModel.swift
//  Received
//
//  Created by MaraMincho on 7/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - FriendModel

struct FriendModel: Codable, Equatable {
  let id: Int64
  let name: String
  let phoneNumber: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case phoneNumber
  }
}
