//
//  MyStatisticsView.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct MyStatisticsView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyStatistics>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView(.vertical) {
      VStack(spacing: 8) {
        makeHistoryView()
        makeMostSpendMonth()
        makeHalfCardView()
        makeMostReceivedPriceCard()
        makeMostSentPriceCard()
      }
      .padding(.horizontal, 16)
    }
  }

  @ViewBuilder
  private func makeHistoryView() -> some View {
    HistoryVerticalChartView(
      historyHeights: store
        .helper
        .historyData
        .enumerated()
        .map { .init(id: $0.offset, height: CGFloat($0.element), caption: "\($0.offset + 1)월") },
      chartTitle: "최근 8개월간 쓴 금액",
      chartTopTrailingDescription: "0만원"
    )
  }

  @ViewBuilder
  private func makeMostSpendMonth() -> some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("경조사비를 가장 많이 쓴 달")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text("?월")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(store.helper.mostEventText != nil ? SSColor.blue60 : SSColor.gray40)
      }
      .frame(maxWidth: .infinity)
      .padding(16)
      .background(SSColor.gray10)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
  }

  @ViewBuilder
  private func makeHalfCardView() -> some View {
    HStack(spacing: 8) {
      let helper = store.helper
      // 최다 친구 관계
      StatisticsType1Card(
        property: .init(
          title: "최다 친구 관계",
          description: helper.mostRelationshipText ?? "?",
          caption: "총 \(helper.mostRelationshipFrequency ?? 0)번",
          isEmptyState: helper.mostRelationshipText == nil || helper.mostRelationshipFrequency == nil
        )
      )
      // 최다 경조사
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 경조사",
          description: helper.mostEventText ?? "?",
          caption: "총 \(helper.mostEventFrequency ?? 0)번",
          isEmptyState: helper.mostEventText == nil || helper.mostEventFrequency == nil
        )
      )
    }
  }

  @ViewBuilder
  private func makeMostReceivedPriceCard() -> some View {
    let helper = store.helper
    StatisticsType2Card(
      property:
      .init(
        isEmptyState: helper.mostReceivedPrice == nil,
        type: .twoLine(
          title: "가장 많이 받은 금액",
          leadingDescription: helper.mostReceivedPersonName ?? "?",
          trailingDescription: "\(helper.mostReceivedPrice?.description ?? "?") 원"
        )
      )
    )
  }

  @ViewBuilder
  private func makeMostSentPriceCard() -> some View {
    let helper = store.helper
    StatisticsType2Card(
      property: .init(
        isEmptyState: helper.mostSentPersonName == nil || helper.mostSentPrices == nil,
        type: .twoLine(
          title: "가장 많이 보낸 금액",
          leadingDescription: helper.mostSentPersonName ?? "?",
          trailingDescription: "\(helper.mostSentPrices?.description ?? "?") 원"
        )
      )
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      makeContentView()
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}