//
//  MyStatisticsProperty.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct MyStatisticsProperty: Equatable {
  var toDecimal: (Int64?) -> String? {
    CustomNumberFormatter.toDecimal
  }

  var mostSpentMonth: String? { myStatisticsResponse?.mostSpentMonth?.description }

  var mostRelationshipText: String? { myStatisticsResponse?.mostRelationship?.title }
  var mostRelationshipFrequency: String? { toDecimal(myStatisticsResponse?.mostRelationship?.value) }

  var mostEventText: String? { myStatisticsResponse?.mostCategory?.title }
  var mostEventFrequency: String? { toDecimal(myStatisticsResponse?.mostCategory?.value) }

  var mostReceivedPersonName: String? { myStatisticsResponse?.highestAmountReceived?.title }
  var mostReceivedPrice: String? { toDecimal(myStatisticsResponse?.highestAmountReceived?.value) }

  var mostSentPersonName: String? { myStatisticsResponse?.highestAmountSent?.title }
  var mostSentPrices: String? { toDecimal(myStatisticsResponse?.highestAmountSent?.value) }

  var historyData = [0, 0, 0, 0, 0, 0, 0, 0]
  var initialData = [0, 0, 0, 0, 0, 0, 0, 0]
  var fakeHistoryData = [40, 40, 30, 20, 10, 50, 60, 20]

  var myStatisticsResponse: UserEnvelopeStatisticResponse? = nil

  var emptyStatisticsResponse: UserEnvelopeStatisticResponse = .emptyState

  var isEmptyState: Bool {
    myStatisticsResponse == emptyStatisticsResponse
  }

  mutating func setHistoryData() {
    historyData = fakeHistoryData
  }

  mutating func updateUserEnvelopeStatistics(_ value: UserEnvelopeStatisticResponse) {
    myStatisticsResponse = value
  }

  // TODO: Some 로직
  mutating func setInitialHistoryData() {
    historyData = initialData
  }

  init() {}
}
