//
//  SearchLedgerResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchLedgerResponse

public struct SearchLedgerResponse: Codable {
  public let ledger: LedgerModel
  public let category: CategoryWithCustomModel
  /// 총 금액
  public let totalAmounts: Int64
  /// 총 봉투 갯수
  public let totalCounts: Int64
  enum CodingKeys: CodingKey {
    case ledger
    case category
    case totalAmounts
    case totalCounts
  }
}
