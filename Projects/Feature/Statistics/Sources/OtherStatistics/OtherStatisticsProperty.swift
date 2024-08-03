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
  mutating func updateSUSUStatistics(_ val: SUSUEnvelopeStatisticResponse) {
    susuStatistics = val

    if let relation = val.mostRelationship {
      relationProperty.leadingDescription = relation.title
      relationProperty.trailingDescription = toDecimal(relation.value) ?? "50,000원"
    }

    if let category = val.mostCategory {
      categoryProperty.leadingDescription = category.title
      categoryProperty.trailingDescription = toDecimal(category.value) ?? "100,000원"
    }
  }

  var selectedAgeItem: Age? = .TWENTY

  var relationItems: [RelationBottomSheetItem] = []
  var selectedRelationItem: RelationBottomSheetItem? = nil
  var selectedRelationshipID: Int? { selectedRelationItem?.id }

  mutating func updateRelationItem(_ items: [RelationBottomSheetItem] ) {
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

  // HistoryProperty
  var historyData = [0, 0, 0, 0, 0, 0, 0, 0]
  var initialData = [0, 0, 0, 0, 0, 0, 0, 0]
  var fakeHistoryData = [40, 40, 30, 20, 10, 50, 60, 20]


  init() {

    relationProperty = .init(
      title: "관계별 평균 수수",
      leadingDescription: "친구",
      trailingDescription: "50,000원",
      isEmptyState: false
    )
    categoryProperty = .init(
      title: "경조사 카테고리별 수수",
      leadingDescription: "결혼식",
      trailingDescription: "300,000원",
      isEmptyState: false
    )
  }

  mutating func setHistoryData() {
    historyData = fakeHistoryData
  }

  mutating func setInitialHistoryData() {
    historyData = initialData
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
