//
//  SelectYearItem.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SelectYearListProperty: Equatable {
  let items: [SelectYearItem]
  init() {
    let nowYear = Int(SelectYearItemDateFormatter.yearStringFrom(date: .now))
    let maxYearRange = nowYear ?? 2024
    items = (1950 ... maxYearRange).map { .init(dateTitle: $0.description) }.reversed()
  }

  struct SelectYearItem: Identifiable, Equatable {
    let id: UUID = .init()
    var date: Date? {
      SelectYearItemDateFormatter.dateFrom(string: dateTitle)
    }

    var dateTitle: String

    init(dateTitle: String) {
      self.dateTitle = dateTitle
    }
  }
}
