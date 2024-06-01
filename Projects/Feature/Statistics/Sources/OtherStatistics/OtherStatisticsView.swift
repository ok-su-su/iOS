//
//  OtherStatisticsView.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - OtherStatisticsView

struct OtherStatisticsView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OtherStatistics>

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
      Text("평균 수수 보기")
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
              buttonText: "20대"
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
              buttonText: store.helper.relationship
            )) {
              // 관계 클릭했을 떄 Some Touch logic
              withAnimation {
                store.send(.view(.tappedRelationshipButton))
                return ()
              }
            }
            .padding(.trailing, 4)

          SSButton(
            .init(
              size: .xsh28,
              status: .active,
              style: .ghost,
              color: .orange,
              rightIcon: .icon(SSImage.envelopeDownArrow),
              buttonText: "결혼식"
            )) {
              // 경조사 클릭했을 떄 Some Touch logic
            }
            .contentMargins(.trailing, 4)

          Text("에")
            .modifier(SSTypoModifier(.title_xxs))
            .foregroundStyle(SSColor.gray80)
        }

        // BottomSection
        HStack(spacing: 8) {
          Text("50,000원")
            .modifier(SSTypoModifier(.title_s))
            .foregroundStyle(SSColor.orange60)

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
    StatisticsType2CardWithAnimation(property: $store.helper.eventProperty)
  }

  @ViewBuilder
  private func makeHistoryView() -> some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("최근 8개월간 쓴 금액")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text("0만원")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(SSColor.blue60)
        // TODO: - Empty일 떄 로직 세우기
//          .foregroundColor(isData ? SSColor.blue60 : SSColor.gray40)
      }

      HStack(spacing: 12) {
        let fakeData = store.helper.historyData
        ForEach(0 ..< fakeData.count, id: \.self) { ind in
          let curData = fakeData[ind]
          VStack(spacing: 4) {
            Spacer()
            SSColor
              .orange30
              .frame(maxWidth: 24, maxHeight: CGFloat(curData))
              .clipShape(RoundedRectangle(cornerRadius: 4))

            Text("\(ind + 1)월")
              .modifier(SSTypoModifier(.title_xxxs))
              .foregroundStyle(SSColor.gray40)
          }
          .frame(maxWidth: 24, minHeight: 104)
        }
      }
    }
    .padding(16)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  @ViewBuilder
  private func makeMostSpendMonth() -> some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("경조사비를 가장 많이 쓴 달")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text(store.helper.mostSpentMonthText)
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
      let helper = store.helper
      // 최다 친구 관계
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 관계",
          description: "친구",
          caption: "평균 12번",
          isEmptyState: false
        )
      )
      // 최다 경조사
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 경조사",
          description: "결혼식",
          caption: "평균 3번",
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
    .sheet(item: $store.scope(state: \.agedBottomSheet, action: \.scope.agedBottomSheet)) { store in
      SelectBottomSheetView(store: store)
        .presentationDetents([.height(240), .medium, .large])
        .presentationContentInteraction(.scrolls)
        .presentationDragIndicator(.automatic)
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
