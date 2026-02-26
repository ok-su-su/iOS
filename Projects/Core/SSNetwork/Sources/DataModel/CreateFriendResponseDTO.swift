//
//  CreateFriendResponseDTO.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateFriendResponseDTO

public struct CreateFriendResponseDTO: Decodable, Equatable, Sendable {
  public let id: Int64
  enum CodingKeys: CodingKey {
    case id
  }
}
