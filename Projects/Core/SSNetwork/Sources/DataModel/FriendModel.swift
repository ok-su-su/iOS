//
//  FriendModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - FriendModel

public struct FriendModel: Codable, Equatable {
  public let id: Int64
  public let name: String
  public let phoneNumber: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case phoneNumber
  }
}
