//
//  CreateAndUpdateLedgerResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct CreateAndUpdateLedgerResponse: Decodable, Sendable {
  public let ledger: LedgerModel
  public let category: CategoryWithCustomModel

  enum CodingKeys: CodingKey {
    case ledger
    case category
  }
}
