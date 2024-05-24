//
//  MyStatisticsProperty.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct MyStatisticsProperty: Equatable {
  var mostRelationshipText: String?
  var mostRelationshipFrequency: Int?

  var mostEventText: String?
  var mostEventFrequency: Int?

  var mostReceivedPersonName: String?
  var mostReceivedPrice: Int?

  var mostSentPersonName: String?
  var mostSentPrices: Int?

  var historyData = [0, 0, 0, 0, 0, 0, 0, 0]
  var fakeHistoryData = [40, 40, 30, 20, 10, 50, 60, 20]

  init() {
    mostRelationshipText = "친구"
    mostRelationshipFrequency = 12
    mostEventText = "결혼식"
    mostEventFrequency = 3
    mostReceivedPersonName = "김민지"
    mostReceivedPrice = 300_000

    mostSentPersonName = "최지환"
    mostSentPrices = 1_000_000
  }

  init(
    mostRelationshipText: String?,
    mostRelationshipFrequency: Int?,
    mostEventText: String?,
    mostEventFrequency: Int?,
    mostReceivedPersonName: String?,
    mostReceivedPrice: Int?,
    mostSentPersonName: String?,
    mostSentPrices: Int?
  ) {
    self.mostRelationshipText = mostRelationshipText
    self.mostRelationshipFrequency = mostRelationshipFrequency
    self.mostEventText = mostEventText
    self.mostEventFrequency = mostEventFrequency
    self.mostReceivedPersonName = mostReceivedPersonName
    self.mostReceivedPrice = mostReceivedPrice
    self.mostSentPersonName = mostSentPersonName
    self.mostSentPrices = mostSentPrices
  }
}
