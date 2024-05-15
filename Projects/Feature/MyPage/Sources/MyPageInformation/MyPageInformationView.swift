//
//  MyPageInformationView.swift
//  MyPage
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct MyPageInformationView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyPageInformation>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      SSImage
        .mypageSusu
        .frame(width: 88, height: 88)
        .clipShape(.circle)
        .padding(.vertical, Metrics.profileVerticalSpacing)

      ForEach(store.scope(state: \.listItems, action: \.scope.listItems)) { store in
        MyPageInformationListViewCell(store: store)
      }

      Spacer()
    }
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
        .gray10
        .ignoresSafeArea()

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .safeAreaInset(edge: .bottom) { makeTabBar() }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let profileVerticalSpacing: CGFloat = 16
    static let profileWidthAndHeight: CGFloat = 88
  }

  private enum Constants {}
}
