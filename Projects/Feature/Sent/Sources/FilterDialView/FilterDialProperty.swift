//
//  FilterDialProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct FilterDialProperty: Equatable {
  var currentType: FilterType = .newest

  enum FilterType: Equatable, CaseIterable {
    case newest
    case oldest
    case maximumPrice
    case minimumPrice
  }
}
