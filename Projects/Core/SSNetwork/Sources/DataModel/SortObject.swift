//
//  SortObject.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SortObject

public struct SortObject: Codable, Equatable {
  public let empty, unsorted, sorted: Bool
  enum CodingKeys: CodingKey {
    case empty
    case unsorted
    case sorted
  }
}
