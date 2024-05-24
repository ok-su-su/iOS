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
    VStack(spacing: 8) {}
  }

  @ViewBuilder
  private func makeHistoryView() -> some View {
    var isData = store.helper != nil
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("최근 8개월간 쓴 금액")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        Text("0만원")
          .modifier(SSTypoModifier(.title_xs))
          .foregroundColor(isData ? SSColor.blue60 : SSColor.gray40)

        if let helper = store.helper {}
      }
      .frame(maxWidth: .infinity)
      .padding(16)
      .background(SSColor.gray10)
      .clipShape(RoundedRectangle(cornerRadius: 4))
    }
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
