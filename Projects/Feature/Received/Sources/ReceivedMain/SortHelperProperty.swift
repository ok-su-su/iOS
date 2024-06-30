//
//  FilterHelper.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSBottomSelectSheet

struct SortHelperProperty: Equatable {
  /// 선택된 다이얼 입니다. 
  var selectedFilterDial: SortDialItem? = .latest
  var defaultItems: [SortDialItem] = SortDialItem.allCases
}



enum SortDialItem: Int, SSSelectBottomSheetPropertyItemable, CaseIterable {
  case latest = 0
  case oldest
  case highestAmount
  case lowestAmount

  var description: String {
    switch self {
    case .latest:
      "최신순"
    case .oldest:
      "오래된순"
    case .highestAmount:
      "금액 높은 순"
    case .lowestAmount:
      "금액 낮은 순"
    }
  }

  var id: Int { rawValue }

  var sortString: String {
    switch self {
    case .latest:
      "createdAt,desc"
    case .oldest:
      "createdAt,asc"
    case .highestAmount:
      "amount,desc"
    case .lowestAmount:
      "amount,asc"
    }
  }
}

extension [SortDialItem] {
  static var `default`: Self {
    return [
      .latest,
      .oldest,
      .highestAmount,
      .lowestAmount,
    ]
  }

  static var initialValue: SortDialItem {
    .latest
  }
}
