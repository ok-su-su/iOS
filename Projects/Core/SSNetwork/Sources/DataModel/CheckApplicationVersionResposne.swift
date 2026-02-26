//
//  CheckApplicationVersionResposne.swift
//  SSNetwork
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct CheckApplicationVersionResponse: Decodable, Sendable {
  public let needForceUpdate: Bool

  enum CodingKeys: CodingKey {
    case needForceUpdate
  }
}
