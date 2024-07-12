//
//  SearchFilterEnvelopeResponse.swift
//  Sent
//
//  Created by MaraMincho on 7/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SearchFilterEnvelopeResponse: Decodable {
  let minReceivedAmount: Int64
  let maxReceivedAmount: Int64
  let minSentAmount: Int64
  let maxSentAmount: Int64
  let totalAmount: Int64

  enum CodingKeys: CodingKey {
    case minReceivedAmount
    case maxReceivedAmount
    case minSentAmount
    case maxSentAmount
    case totalAmount
  }
}
