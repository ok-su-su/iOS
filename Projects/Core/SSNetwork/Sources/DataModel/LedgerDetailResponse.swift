//
//  LedgerDetailResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - LedgerDetailResponse

public struct LedgerDetailResponse: Decodable {
  public let ledger: LedgerModel
  public let category: CategoryWithCustomModel
  public let totalAmounts: Int64
  public let totalCounts: Int64
}
