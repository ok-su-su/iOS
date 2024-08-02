//
//  SUSUStatisticsRequestProperty.swift
//  Statistics
//
//  Created by MaraMincho on 8/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSBottomSelectSheet

// MARK: - Age

enum Age: String, SSSelectBottomSheetPropertyItemable, CaseIterable {
  case TEN
  case TWENTY
  case THIRTY
  case FOURTY
  case FIFTY
  case SIXTY
  case SEVENTY

  var description: String {
    switch self {
    case .TEN:
      "10대"
    case .TWENTY:
      "20대"
    case .THIRTY:
      "30대"
    case .FOURTY:
      "40대"
    case .FIFTY:
      "50대"
    case .SIXTY:
      "60대"
    case .SEVENTY:
      "70대"
    }
  }

  var id: Int {
    let allCases = Age.allCases.enumerated()
    return (allCases.first(where: { $0.element == self })?.offset) ?? 0
  }
}

// MARK: - SUSUStatisticsRequestProperty

struct SUSUStatisticsRequestProperty {
  var age: Age?
  var relationshipId: Int64?
  var categoryId: Int64?
}

extension SUSUStatisticsRequestProperty {
  func getQueryString() -> [String: String] {
    var res: [String: String] = [:]

    if let age {
      res["age"] = age.rawValue
    }
    if let relationshipId {
      res["relationshipId"] = relationshipId.description
    }
    if let categoryId {
      res["categoryId"] = categoryId.description
    }
    return res
  }
}
