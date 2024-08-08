//
//  OtherStatisticsProperty.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSBottomSelectSheet

// MARK: - OtherStatisticsProperty

struct OtherStatisticsProperty: Equatable {
  var toDecimal: (Int64) -> String? { CustomNumberFormatter.toDecimal }

  var relationProperty: StatisticsType2CardWithAnimationProperty
  var categoryProperty: StatisticsType2CardWithAnimationProperty

  var susuStatistics: SUSUEnvelopeStatisticResponse = .emptyState

  var nowSentPrice: String = ""
  var nowSentPriceSlice: [String] = []

  mutating func updateSentText(_ value: String) {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal

    nowSentPrice = value
    let num = Int(String(nowSentPrice.compactMap(\.wholeNumberValue).map { String($0) }.joined()))!
    nowSentPriceSlice = formatter.string(from: .init(value: num))!.map { String($0) }
  }

  mutating func updateSUSUStatistics(_ val: SUSUEnvelopeStatisticResponse) {
    susuStatistics = val

    if let nowSentPrice = val.averageSent {
      updateSentText(nowSentPrice.description)
    }

    if let relation = val.averageRelationship {
      relationProperty.leadingDescription = relation.title
      let trailingText = toDecimal(relation.value) ?? ""
      relationProperty.updateTrailingText(trailingText)
    }

    if let category = val.averageCategory {
      categoryProperty.leadingDescription = category.title
      let trailingText = toDecimal(category.value) ?? ""
      categoryProperty.updateTrailingText(trailingText)
    }

    chartProperty.updateItems(val.recentSpent)
  }

  var selectedAgeItem: Age? = .TWENTY

  var relationItems: [RelationBottomSheetItem] = []
  var selectedRelationItem: RelationBottomSheetItem? = nil
  var selectedRelationshipID: Int? { selectedRelationItem?.id }

  mutating func updateRelationItem(_ items: [RelationBottomSheetItem]) {
    relationItems = items
    selectedRelationItem = relationItems.first
  }

  var categoryItems: [CategoryBottomSheetItem] = []
  var selectedCategoryItem: CategoryBottomSheetItem? = nil
  var selectedCategoryID: Int? { selectedCategoryItem?.id }

  mutating func updateCategoryItem(_ items: [CategoryBottomSheetItem]) {
    categoryItems = items
    selectedCategoryItem = categoryItems.first
  }

  var chartProperty: HistoryVerticalChartViewProperty = .emptyState
  var chartTotalPrice: Int64 { chartProperty.totalPrice / 10000 }

  init() {
    relationProperty = .init(
      title: "관계별 평균 수수",
      leadingDescription: "친구",
      trailingDescription: "",
      isEmptyState: false
    )
    categoryProperty = .init(
      title: "경조사 카테고리별 수수",
      leadingDescription: "결혼식",
      trailingDescription: "",
      isEmptyState: false
    )
  }
}

// MARK: - RelationBottomSheetItem

struct RelationBottomSheetItem: SSSelectBottomSheetPropertyItemable {
  var description: String
  var id: Int
}

// MARK: - CategoryBottomSheetItem

struct CategoryBottomSheetItem: SSSelectBottomSheetPropertyItemable {
  var description: String
  var id: Int
}
