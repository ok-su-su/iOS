//
//  OtherStatisticsProperty.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct OtherStatisticsProperty: Equatable {
  var eventName: String
  var aged: String
  var relationship: String
  var topSectionPrice: Int
  var relationProperty: StatisticsType2CardProperty
  var eventProperty: StatisticsType2CardProperty
  var mostSpentMonthText: String = "3월"

  // HistoryProperty
  var historyData = [0, 0, 0, 0, 0, 0, 0, 0]
  var initialData = [0, 0, 0, 0, 0, 0, 0, 0]
  var fakeHistoryData = [40, 40, 30, 20, 10, 50, 60, 20]

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

    relationProperty = .init(
      title: "관계별 평균 수수",
      leadingDescription: relationship,
      trailingDescription: "500,000원",
      isEmptyState: false
    )
    eventProperty = .init(
      title: "경조사 카테고리별 수수",
      leadingDescription: relationship,
      trailingDescription: "300,000원",
      isEmptyState: false
    )
  }

  init() {
    aged = "20대"
    eventName = "돌잔치"
    relationship = "가족"
    topSectionPrice = 100_000

    relationshipAveragePrice = 100_000
    eventAveragePrice = 52000

    relationProperty = .init(
      title: "관계별 평균 수수",
      leadingDescription: relationship,
      trailingDescription: "500,000원",
      isEmptyState: false
    )
    eventProperty = .init(
      title: "경조사 카테고리별 수수",
      leadingDescription: relationship,
      trailingDescription: "300,000원",
      isEmptyState: false
    )
  }

  mutating func fakeSetRelationship() {
    relationship = ["친구", "가족"].randomElement()!
    relationProperty.leadingDescription = relationship
    relationProperty.updateTrailingText(["100000원", "300000원", "150000원"].randomElement()!)
  }

  mutating func setHistoryData() {
    historyData = fakeHistoryData
  }

  mutating func setInitialHistoryData() {
    historyData = initialData
  }
}
