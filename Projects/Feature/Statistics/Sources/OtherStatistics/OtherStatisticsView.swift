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
    VStack(spacing: 0) {
      makeAverageTopSection()
      makeRelationAverage()

      Text(store.price.description)
        .contentTransition(.numericText())

      Button {
        withAnimation {
          store.send(.view(.tappedButton))
          return ()
        }

      } label: {
        Text("눌러용")
      }
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
              // 연령 클릭했을 떄 Some Touch logic
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

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
