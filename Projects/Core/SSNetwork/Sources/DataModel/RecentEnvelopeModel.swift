//
//  RecentEnvelopeModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - RecentEnvelopeModel

public struct RecentEnvelopeModel: Equatable, Codable, Sendable {
  public let category, handedOverAt: String
  enum CodingKeys: CodingKey {
    case category
    case handedOverAt
  }
}
