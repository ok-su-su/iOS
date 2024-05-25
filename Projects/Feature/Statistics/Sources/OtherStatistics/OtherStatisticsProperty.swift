//
//  OtherStatisticsProperty.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct OtherStatisticsProperty {
  var eventName: String
  var aged: String
  var relationship: String
  var topSectionPrice: Int

  var relationshipAveragePrice: Int
  var eventAveragePrice: Int

  mutating func fakeValue() {
    aged = "20대"
    eventName = "돌잔치"
    relationship = "가족"
    topSectionPrice = 100_000

    relationshipAveragePrice = 100_000
    eventAveragePrice = 52000
  }

  init(eventName: String, aged: String, relationship: String, topSectionPrice: Int, relationshipAveragePrice: Int, eventAveragePrice: Int) {
    self.eventName = eventName
    self.aged = aged
    self.relationship = relationship
    self.topSectionPrice = topSectionPrice
    self.relationshipAveragePrice = relationshipAveragePrice
    self.eventAveragePrice = eventAveragePrice
  }

  init() {
    aged = "20대"
    eventName = "돌잔치"
    relationship = "가족"
    topSectionPrice = 100_000

    relationshipAveragePrice = 100_000
    eventAveragePrice = 52000
  }
}
