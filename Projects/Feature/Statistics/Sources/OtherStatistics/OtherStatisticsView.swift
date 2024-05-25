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

struct OtherStatisticsView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OtherStatistics>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
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
