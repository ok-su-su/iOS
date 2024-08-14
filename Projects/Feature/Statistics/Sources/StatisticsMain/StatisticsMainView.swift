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
    VStack(spacing: 0) {
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
        Button {
          store.send(.view(.tappedStepper(type)))
        } label: {
          Text(type.title)
            .modifier(SSTypoModifier(.title_xxxs))
            .foregroundStyle(isSelected ? SSColor.gray100 : SSColor.gray50)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isSelected ? SSColor.gray20 : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 4))
      }
    }
    .frame(maxWidth: .infinity)
    .padding(4)
    .background(SSColor.gray10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
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
    .addSSTabBar(store.scope(state: \.tabBar, action: \.scope.tabBar))
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
