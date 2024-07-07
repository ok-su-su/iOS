//
//  CreateAndUpdateLedgerResponse.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct CreateAndUpdateLedgerResponse: Decodable{
  let ledger: LedgerModel
  let category:  CategoryWithCustomModel

  enum CodingKeys: CodingKey {
    case ledger
    case category
  }
}
