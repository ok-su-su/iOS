//
//  FilterDialProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import Foundation

// MARK: - FilterDialProperty

struct FilterDialProperty: Equatable {
  var currentType: FilterDialType = .newest
  var types = FilterDialType.allCases
}

// MARK: - FilterDialType

enum FilterDialType: Equatable, CaseIterable {
  case newest
  case oldest
  case maximumPrice
  case minimumPrice

  var name: String {
    switch self {
    case .maximumPrice:
      "금액 높은 순"
    case .minimumPrice:
      "금액 낮은 순"
    case .newest:
      "최신 순"
    case .oldest:
      "오래된 순"
    }
  }
}
