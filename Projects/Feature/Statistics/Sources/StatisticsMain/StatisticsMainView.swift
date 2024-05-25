//
//  StatisticsMainView.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct StatisticsMainView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<StatisticsMain>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 8) {
      makeTopStepper()
      switch store.helper.selectedStepperType {
      case .my:
        MyStatisticsView(store: store.scope(state: \.myStatistics, action: \.scope.myStatistics))
      case .other:
        OtherStatisticsView(store: store.scope(state: \.otherStatistics, action: \.scope.otherStatistics))
      }
    }
  }

  @ViewBuilder
  private func makeTopStepper() -> some View {
    HStack(alignment: .top, spacing: 4) {
      ForEach(StepperType.allCases) { type in
        let isSelected = type == store.helper.selectedStepperType
        Text(type.title)
          .modifier(SSTypoModifier(.title_xxxs))
          .foregroundStyle(isSelected ? SSColor.gray100 : SSColor.gray50)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .frame(maxWidth: .infinity, alignment: .center)
          .background(isSelected ? SSColor.gray20 : Color.clear)
          .onTapGesture {
            store.send(.view(.tappedStepper(type)))
          }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(4)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeTabBar() -> some View {
    SSTabbar(store: store.scope(state: \.tabBar, action: \.scope.tabBar))
      .background {
        Color.white
      }
      .ignoresSafeArea()
      .frame(height: 56)
      .toolbar(.hidden, for: .tabBar)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) { makeTabBar() }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
