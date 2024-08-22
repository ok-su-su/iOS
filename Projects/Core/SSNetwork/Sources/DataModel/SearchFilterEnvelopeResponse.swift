//
//  SearchFilterEnvelopeResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct SearchFilterEnvelopeResponse: Decodable {
  public let minReceivedAmount: Int64
  public let maxReceivedAmount: Int64
  public let minSentAmount: Int64
  public let maxSentAmount: Int64
  public let totalAmount: Int64

  enum CodingKeys: CodingKey {
    case minReceivedAmount
    case maxReceivedAmount
    case minSentAmount
    case maxSentAmount
    case totalAmount
  }
}
