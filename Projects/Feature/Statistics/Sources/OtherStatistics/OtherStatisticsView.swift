//
//  OtherStatisticsView.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SwiftUI

// MARK: - OtherStatisticsView

struct OtherStatisticsView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OtherStatistics>

  var statisticsProperty: SUSUEnvelopeStatisticResponse { store.helper.susuStatistics }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 8) {
      makeAverageTopSection()
      makeRelationAverage()
      makeEventAverage()
      makeHistoryView()
      makeMostSpendMonth()
      makeHalfCardView()
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeAverageTopSection() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(Constants.nowSUSUStatisticsLabel)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray50)

      VStack(alignment: .leading, spacing: 8) {
        // TopSection
        HStack(spacing: 0) {
          SSButton(
            .init(
              size: .xsh28,
              status: .active,
              style: .ghost,
              color: .orange,
              rightIcon: .icon(SSImage.envelopeDownArrow),
              buttonText: store.helper.selectedAgeItem?.description ?? "20 대"
            )) {
              store.send(.view(.tappedAgedButton))
            }
            .padding(.trailing, 4)

          Text("는")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundStyle(SSColor.gray80)
            .padding(.trailing, 16)

          SSButton(
            .init(
              size: .xsh28,
              status: .active,
              style: .ghost,
              color: .orange,
              rightIcon: .icon(SSImage.envelopeDownArrow),
              buttonText: store.helper.selectedRelationItem?.description ?? "친구"
            )) {
              store.send(.view(.tappedRelationshipButton))
            }
            .padding(.trailing, 4)

          SSButton(
            .init(
              size: .xsh28,
              status: .active,
              style: .ghost,
              color: .orange,
              rightIcon: .icon(SSImage.envelopeDownArrow),
              buttonText: store.helper.selectedCategoryItem?.description ?? "결혼식"
            )) {
              store.sendViewAction(.tappedCategoryButton)
            }
            .contentMargins(.trailing, 4)

          Text("에")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundStyle(SSColor.gray80)
        }

        // BottomSection
        HStack(spacing: 8) {
          CustomNumericNumberView(
            descriptionSlice: $store.helper.nowSentPriceSlice,
            isEmptyState: false,
            height: 30
          )

          Text("보내고 있어요")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundStyle(SSColor.gray80)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(SSColor.orange10)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  @ViewBuilder
  private func makeRelationAverage() -> some View {
    StatisticsType2CardWithAnimation(property: $store.helper.relationProperty)
  }

  @ViewBuilder
  private func makeEventAverage() -> some View {
    StatisticsType2CardWithAnimation(property: $store.helper.categoryProperty)
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

        Text(statisticsProperty.mostSpentMonth?.description ?? "3" + "월")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.blue60)
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
      // 최다 수수 관계
      let relationTitle = statisticsProperty.mostRelationship?.title ?? "친구"
      let relationCount = CustomNumberFormatter.toDecimal(statisticsProperty.mostRelationship?.value) ?? "12"
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 관계",
          description: relationTitle,
          caption: "평균 " + relationCount + " 번",
          isEmptyState: false
        )
      )
      // 최다 경조사
      let categoryTitle = statisticsProperty.mostCategory?.title ?? "결혼식"
      let categoryCount = CustomNumberFormatter.toDecimal(statisticsProperty.mostCategory?.value) ?? "12"
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 경조사",
          description: categoryTitle,
          caption: "평균 " + categoryCount + " 번",
          isEmptyState: false
        )
      )
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      ScrollView {
        VStack(spacing: 0) {
          makeContentView()
        }
      }
    }
    .selectableBottomSheet(
      store: $store.scope(state: \.agedBottomSheet, action: \.scope.agedBottomSheet),
      cellCount: Age.allCases.count
    )
    .selectableBottomSheet(
      store: $store.scope(state: \.categoryBottomSheet, action: \.scope.categoryBottomSheet),
      cellCount: store.state.helper.categoryItems.count
    )
    .selectableBottomSheet(
      store: $store.scope(state: \.relationBottomSheet, action: \.scope.relationBottomSheet),
      cellCount: store.state.helper.relationItems.count
    )
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let nowSUSUStatisticsLabel: String = "지금 평균 수수 보기"
  }
}
