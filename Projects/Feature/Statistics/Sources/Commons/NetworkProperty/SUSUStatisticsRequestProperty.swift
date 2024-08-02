//
//  SUSUStatisticsRequestProperty.swift
//  Statistics
//
//  Created by MaraMincho on 8/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SUSUStatisticsRequestProperty

struct SUSUStatisticsRequestProperty {
  var age: Age?
  var relationshipId: Int64?
  var categoryId: Int64?
  enum Age: String {
    case TEN
    case TWENTY
    case THIRTY
    case FOURTY
    case FIFTY
    case SIXTY
    case SEVENTY
  }
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
