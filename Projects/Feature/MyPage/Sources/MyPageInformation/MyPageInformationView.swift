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
      ForEach(store.scope(state: \.listItems, action: \.scope.listItems)) { store in
        MyPageInformationListViewCell(store: store)
      }
      Spacer()
    }
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
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
