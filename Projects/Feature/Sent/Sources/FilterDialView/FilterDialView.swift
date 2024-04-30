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
  private func makeContentView() -> some View {}

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack {
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
