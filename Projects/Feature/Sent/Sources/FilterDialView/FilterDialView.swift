//
//  FilterDialView.swift
//  Sent
//
//  Created by MaraMincho on 4/30/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct FilterDialView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<FilterDial>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ForEach(0 ..< store.filterDialProperty.types.count, id: \.self) { ind in
      let curSelected = store.filterDialProperty.currentType
      let cur = store.filterDialProperty.types[ind]
      SSButton(
        .init(
          size: .sh48,
          status: cur == curSelected ? .active : .inactive,
          style: .ghost,
          color: .black,
          buttonText: cur.name,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.tappedDial(cur))
        }
    }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack {
        Spacer()
          .frame(height: 16)
        makeContentView()
      }
    }
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
