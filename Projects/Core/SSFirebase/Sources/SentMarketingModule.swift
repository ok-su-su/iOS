//
//  SentMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
// MARK: - SentMarketingModule

public enum SentMarketingModule: CustomStringConvertible, Equatable {
  case main
  case filter
  case search
  case specific
  case envelope(EnvelopeMarketingModule)
  public var description: String {
    switch self {
    case .main:
      "메인"
    case .filter:
      "필터"
    case .search:
      "검색"
    case .specific:
      "인물봉투"
    case let .envelope(current):
      current.description
    }
  }
}
