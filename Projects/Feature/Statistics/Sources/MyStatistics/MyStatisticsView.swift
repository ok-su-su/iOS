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
    VStack(spacing: 8) {
      makeHistoryView()
      makeMostSpendMonth()
      makeHalfCardView()
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeHistoryView() -> some View {
    let isData = store.helper != nil
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("최근 8개월간 쓴 금액")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text("0만원")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(isData ? SSColor.blue60 : SSColor.gray40)
      }
      .frame(maxWidth: .infinity)
      .padding(16)
      .background(SSColor.gray10)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
  }

  
  @ViewBuilder
  private func makeMostSpendMonth() -> some View {
    let isData = store.helper != nil
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("경조사비를 가장 많이 쓴 달")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text("?월")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(isData ? SSColor.blue60 : SSColor.gray40)
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
          isEmptyState: helper.mostRelationshipText != nil && helper.mostRelationshipFrequency != nil
        )
      )
      // 최다 경조사
      StatisticsType1Card(
        property: .init(
          title: "최다 수수 경조사",
          description: helper.mostEventText ?? "?",
          caption: "총 \(helper.mostEventFrequency ?? 0)번",
          isEmptyState: helper.mostEventText != nil && helper.mostEventFrequency != nil
        )
      )
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }
  
  @ViewBuilder
  private func makeMostReceivedPriceCard() -> some View {
    
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
