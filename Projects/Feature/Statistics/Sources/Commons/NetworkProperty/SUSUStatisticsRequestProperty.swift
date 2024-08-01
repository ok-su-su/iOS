//
//  SUSUStatisticsRequestProperty.swift
//  Statistics
//
//  Created by MaraMincho on 8/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SUSUStatisticsRequestProperty {
  var age: Age?
  var relationshipId: Int64?
  var categoryId: Int64?
  enum Age: String {
    case TEN, TWENTY, THIRTY, FOURTY, FIFTY, SIXTY, SEVENTY
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
