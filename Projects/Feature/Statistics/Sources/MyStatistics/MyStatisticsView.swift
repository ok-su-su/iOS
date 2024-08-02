//
//  MyStatisticsView.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSAlert
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
        Spacer()
          .frame(maxWidth: .infinity, maxHeight: 0.5)
        makeHistoryView()
        makeMostSpendMonth()
        makeHalfCardView()
        makeMostReceivedPriceCard()
        makeMostSentPriceCard()
      }
      .padding(.horizontal, 16)
    }
    .scrollIndicators(.hidden)
    .contentShape(Rectangle())
    .onTapGesture {
      store.sendViewAction(.tappedScrollView)
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
      chartTitle: Constants.verticalChartSpentMonthTitleLabel,
      chartTopTrailingDescription: "0만원"
    )
  }

  @ViewBuilder
  private func makeMostSpendMonth() -> some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text(Constants.mostSpentMonthTitleLabel)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()
        let targetMonth = store.helper.mostSpentMonth?.description ?? "?"
        Text(targetMonth + "월")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(store.helper.isEmptyState ? SSColor.gray40 : SSColor.blue60)
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
          title: Constants.mostSpentRelationshipTitleLabel,
          description: helper.mostRelationshipText ?? "?",
          caption: "총 \(helper.mostRelationshipFrequency ?? "0") 번",
          isEmptyState: helper.isEmptyState
        )
      )
      // 최다 경조사
      StatisticsType1Card(
        property: .init(
          title: Constants.mostSpentCategoryTitleLabel,
          description: helper.mostEventText ?? "?",
          caption: "총 \(helper.mostEventFrequency ?? "0") 번",
          isEmptyState: helper.isEmptyState
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
        isEmptyState: helper.isEmptyState,
        type: .twoLine(
          title: Constants.mostReceivedTitleLabel,
          leadingDescription: helper.mostReceivedPersonName ?? "?",
          trailingDescription: "\(helper.mostReceivedPrice ?? "?") 원"
        )
      )
    )
  }

  @ViewBuilder
  private func makeMostSentPriceCard() -> some View {
    let helper = store.helper
    StatisticsType2Card(
      property: .init(
        isEmptyState: helper.isEmptyState,
        type: .twoLine(
          title: Constants.mostSentTitleLabel,
          leadingDescription: helper.mostSentPersonName ?? "?",
          trailingDescription: "\(helper.mostSentPrices ?? "?") 원"
        )
      )
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      makeContentView()
    }
    .navigationBarBackButtonHidden()
    .ssLoading(store.isLoading)
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .sSAlert(
      isPresented: $store.isAlert.sending(\.view.isAlert),
      messageAlertProperty: .init(
        titleText: " 아직 볼 수 있는 통계가 없어요",
        contentText: "작성된 봉투 혹은 장부가 있는 경우\n 수수가 데이터를 분석해드려요",
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(
          left: "닫기",
          right: "봉투 작성하기"
        ),
        didTapCompletionButton: { _ in
          store.sendViewAction(.tappedAlertCreateEnvelopeButton)
        }
      )
    )
  }

  private enum Metrics {}

  private enum Constants {
    static let verticalChartSpentMonthTitleLabel: String = "최근 8개월간 쓴 금액"
    static let mostSpentMonthTitleLabel: String = "경조사비를 가장 많이 쓴 달"
    static let mostSpentRelationshipTitleLabel: String = "최다 수수 관계"
    static let mostSpentCategoryTitleLabel: String = "최다 수수 경조사"
    static let mostReceivedTitleLabel: String = "가장 많이 받은 금액"
    static let mostSentTitleLabel: String = "가장 많이 보낸 금액"
  }
}
