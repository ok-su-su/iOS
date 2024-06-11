//
//  LaunchScreenMainView.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct LaunchScreenMainView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<LaunchScreenMain>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {}
  }

  var body: some View {
    ZStack {
      SSColor
        .orange10
        .ignoresSafeArea()

      SSImage
        .commonLogo
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
