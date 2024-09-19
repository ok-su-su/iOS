//
//  StatisticsMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - StatisticsMarketingModule

public enum StatisticsMarketingModule: CustomStringConvertible, Equatable {
  case mine
  case other
  public var description: String {
    switch self {
    case .mine:
      "나의"
    case .other:
      "수수"
    }
  }
}
