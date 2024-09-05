//
//  ReceivedMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - ReceivedMarketingModule

public enum ReceivedMarketingModule: CustomStringConvertible, Equatable {
  case main
  case filter
  case search
  case ledger(LedgerMarketingModule)
  case createLedger(CreateLedgerMarketingModule)
  case createEnvelope(CreateEnvelopeMarketingModule)
  public var description: String {
    switch self {
    case .main:
      "메인"
    case let .createEnvelope(current):
      current.description
    case .filter:
      "필터"
    case .search:
      "검색"
    case let .ledger(current):
      current.description
    case let .createLedger(current):
      current.description
    }
  }
}
