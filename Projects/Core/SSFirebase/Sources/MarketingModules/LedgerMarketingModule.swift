//
//  LedgerMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum LedgerMarketingModule: CustomStringConvertible, Equatable {
  case main
  case envelope(EnvelopeMarketingModule)
  case edit
  public var description: String {
    switch self {
    case .main:
      "장부 메인"
    case let .envelope(current):
      "장부 \(current.description)"
    case .edit:
      "장부 수정"
    }
  }
}
