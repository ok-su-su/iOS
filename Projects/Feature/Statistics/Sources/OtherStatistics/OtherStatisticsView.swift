//
//  OtherStatisticsView.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSAlert
import SSBottomSelectSheet
import SSNetwork
import SSToast
import SwiftUI

// MARK: - OtherStatisticsView

struct OtherStatisticsView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OtherStatistics>

  var statisticsProperty: SUSUEnvelopeStatisticResponse { store.helper.susuStatistics }

  let animationDuration = 0.3

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 8) {
      Spacer()
        .frame(maxWidth: .infinity, maxHeight: 0.5)
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
              rightIcon: .icon(SSImage.statisticsArrow),
              buttonText: store.helper.selectedAgeItem?.topSectionDescriptionLabel ?? "20 대"
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
              rightIcon: .icon(SSImage.statisticsArrow),
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
              rightIcon: .icon(SSImage.statisticsArrow),
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
          if store.helper.isNowSentPriceEmpty {
            Text("?원")
              .foregroundStyle(SSColor.orange60)
              .applySSFont(.title_s)
          } else {
            CustomNumericNumberView(
              descriptionSlice: $store.helper.nowSentPriceSlice,
              animationDuration: animationDuration,
              isEmptyState: false,
              height: 30,
              subFixString: "원",
              textColor: SSColor.orange60
            )
          }

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
    StatisticsType2CardWithAnimation(
      property: $store.helper.relationProperty,
      textColor: SSColor.gray100,
      emptyStateTextColor: SSColor.gray40
    )
  }

  @ViewBuilder
  private func makeEventAverage() -> some View {
    StatisticsType2CardWithAnimation(
      property: $store.helper.categoryProperty,
      animationDuration: animationDuration,
      textColor: SSColor.gray100,
      emptyStateTextColor: SSColor.gray40
    )
  }

  @ViewBuilder
  private func makeHistoryView() -> some View {
    HistoryVerticalChartView(
      property: store.helper.chartProperty,
      chartLeadingLabel: "올해 쓴 금액",
      chartTrailingLabel: store.helper.chartTotalPrice.description + "만원",
      animationDuration: animationDuration
    )
  }

  @ViewBuilder
  private func makeMostSpendMonth() -> some View {
    let mostSpentMonthLabel = (statisticsProperty.mostSpentMonth?.description ?? "?") + "월"
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("경조사비를 가장 많이 쓴 달")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text(mostSpentMonthLabel)
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(statisticsProperty.mostSpentMonth != nil ? SSColor.blue60 : SSColor.gray40)
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
      let relationCount = CustomNumberFormatter.toDecimal(statisticsProperty.mostRelationship?.value) ?? "?"
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 관계",
          description: relationTitle,
          caption: "평균 " + relationCount + "번",
          isEmptyState: store.helper.isEmptyState
        )
      )
      // 최다 경조사
      let categoryTitle = statisticsProperty.mostCategory?.title ?? "결혼식"
      let categoryCount = CustomNumberFormatter.toDecimal(statisticsProperty.mostCategory?.value) ?? "?"
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 경조사",
          description: categoryTitle,
          caption: "평균 " + categoryCount + "번",
          isEmptyState: store.helper.isEmptyState
        )
      )
    }
  }

  private var emptyStateDragGesture: some Gesture {
    DragGesture()
      .onChanged { _ in
        store.sendViewAction(.tappedScrollView)
      }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      ScrollView {
        makeContentView()
      }
      .disabled(store.helper.isEmptyState)

      if store.helper.isEmptyState {
        Color.clear
          .contentShape(Rectangle())
          .onTapGesture {
            store.sendViewAction(.tappedScrollView)
          }
          .gesture(emptyStateDragGesture)
      }
    }
    .showToast(store: store.scope(state: \.toast, action: \.scope.toast))
    .selectableBottomSheet(
      store: $store.scope(state: \.agedBottomSheet, action: \.scope.agedBottomSheet),
      screenRatio: 0.5
    )
    .selectableBottomSheet(
      store: $store.scope(state: \.categoryBottomSheet, action: \.scope.categoryBottomSheet),
      cellCount: store.state.helper.categoryItems.count
    )
    .selectableBottomSheet(
      store: $store.scope(state: \.relationBottomSheet, action: \.scope.relationBottomSheet),
      cellCount: store.state.helper.relationItems.count
    )
    .sSAlert(
      isPresented: $store.presentMyPageEditAlert.sending(\.view.presentMyPageEditAlert), messageAlertProperty:
      .init(
        titleText: Constants.myPageEditAlertTitle,
        contentText: Constants.myPageEditAlertDescription,
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(
          left: Constants.myPageLeadingButtonLabel,
          right: Constants.myPageTrailingButtonLabel
        ),
        didTapCompletionButton: { _ in
          store.sendViewAction(.tappedAlertButton)
        }
      )
    )
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let nowSUSUStatisticsLabel: String = "지금 평균 수수 보기"

    static let myPageEditAlertTitle: String = "통계를 위한 정보를 알려주세요"
    static let myPageEditAlertDescription: String = "나의 평균 거래 상황을 분석하기 위해\n필요한 정보가 있어요"
    static let myPageLeadingButtonLabel: String = "닫기"
    static let myPageTrailingButtonLabel: String = "정보 입력하기"
  }
}
