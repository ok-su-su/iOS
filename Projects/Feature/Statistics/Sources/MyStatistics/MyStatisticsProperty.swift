//
//  MyStatisticsProperty.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct MyStatisticsProperty: Equatable {
  var mostSpentMonth: Int64? { myStatisticsResponse?.mostSpentMonth }
  var mostRelationshipText: String? { myStatisticsResponse?.mostRelationship?.title }
  var mostRelationshipFrequency: Int64? { myStatisticsResponse?.mostRelationship?.value }

  var mostEventText: String? { myStatisticsResponse?.mostCategory?.title }
  var mostEventFrequency: Int64? { myStatisticsResponse?.mostCategory?.value }

  var mostReceivedPersonName: String? { myStatisticsResponse?.highestAmountReceived?.title }
  var mostReceivedPrice: Int64? { myStatisticsResponse?.highestAmountReceived?.value }

  var mostSentPersonName: String? { myStatisticsResponse?.highestAmountSent?.title }
  var mostSentPrices: Int64? { myStatisticsResponse?.highestAmountSent?.value }

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
