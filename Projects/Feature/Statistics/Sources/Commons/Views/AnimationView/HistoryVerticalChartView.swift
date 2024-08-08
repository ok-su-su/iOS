//
//  HistoryVerticalChartView.swift
//  Statistics
//
//  Created by MaraMincho on 6/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - HistoryVerticalChartViewProperty

struct HistoryVerticalChartViewProperty: Equatable {
  var items: [HistoryVerticalChartItem]

  init(items: [HistoryVerticalChartItem]) {
    self.items = items
    updateChartItems()
  }

  mutating func updateChartItems() {
    // prevent devide by zero
    if
      items.isEmpty == false {
      return
    }
    let maxValue = items.max(by: { $0.value > $1.value })?.value ?? 1
    items = items.map { item in
      var item = item
      let portion = Double(item.value) / Double(maxValue)
      item.updatePortion(portion)
      return item
    }
  }
}

extension HistoryVerticalChartViewProperty {
  static var `default`: Self {
    HistoryVerticalChartViewProperty(
      items: DateIDGenerator
        .generateLatestSixMontDateIDAndMonth()
        .map { .init(bottomTitle: $0.month.description + "월", value: 0, id: $0.id, portion: 0) }
    )
  }
}

// MARK: - HistoryVerticalChartItem

struct HistoryVerticalChartItem: Identifiable, Equatable {
  var bottomTitle: String
  var value: Int
  var id: Int64
  init(bottomTitle: String, value: Int, id: Int64) {
    self.bottomTitle = bottomTitle
    self.value = value
    self.id = id
  }

  fileprivate init(bottomTitle: String, value: Int, id: Int64, portion: Double) {
    self.bottomTitle = bottomTitle
    self.value = value
    self.id = id
    self.portion = portion
  }

  fileprivate var portion: Double = 0

  mutating func updatePortion(_ portion: Double) {
    self.portion = portion
  }
}

// MARK: - HistoryVerticalChartView

struct HistoryVerticalChartView: View {
  private var property: HistoryVerticalChartViewProperty
  private var chartLeadingLabel: String
  private var chartTrailingLabel: String

  @State private var isAnimation: Bool = false
  init(
    property: HistoryVerticalChartViewProperty,
    chartLeadingLabel: String,
    chartTrailingLabel: String
  ) {
    self.property = property
    self.chartLeadingLabel = chartLeadingLabel
    self.chartTrailingLabel = chartTrailingLabel
  }

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text(chartLeadingLabel)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text(chartTrailingLabel)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.blue60)
      }

      HStack(spacing: 12) {
        ForEach(property.items, id: \.id) { item in
          let curHeight = CGFloat(item.portion) * Metrics.chartMaximumHeight
          let isLastMonth = item == property.items.last
          VStack(spacing: 4) {
            Spacer()
            SSColor
              .orange30
              .frame(maxWidth: Metrics.chartMaximumWidth, maxHeight: isAnimation ? curHeight : 0)
              .clipShape(RoundedRectangle(cornerRadius: 4))
              .animation(.easeIn(duration: 0.8), value: isAnimation)
              .animation(.easeIn(duration: 0.8), value: item.portion)

            Text(item.bottomTitle)
              .modifier(SSTypoModifier(.title_xxxs))
              .foregroundStyle(isLastMonth ? SSColor.gray90 : SSColor.gray40)
              .lineLimit(1)
          }
          .frame(maxWidth: 24, minHeight: 104)
        }
      }
    }
    .padding(16)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
    .onAppear {
      isAnimation = true
    }
  }

  enum Metrics {
    static let chartMaximumHeight: CGFloat = 80
    static let chartMinimumHeight: CGFloat = 0
    static let chartMaximumWidth: CGFloat = 24
  }
}
