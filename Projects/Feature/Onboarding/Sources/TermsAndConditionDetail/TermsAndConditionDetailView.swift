//
//  TermsAndConditionDetailView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct TermsAndConditionDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<TermsAndConditionDetail>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      ScrollView(.vertical) {
        Text(store.detailDescription)
          .modifier(SSTypoModifier(.text_xxxs))
          .padding(.horizontal, 16)
      }
    }
  }

  @ViewBuilder
  private func makeNextScreenButton() -> some View {
    VStack(spacing: 0) {
      SSButton(.init(
        size: .mh60,
        status: .active,
        style: .filled,
        color: .black,
        buttonText: "동의하기",
        frame: .init(maxWidth: .infinity)
      )) {
        store.send(.view(.tappedAgreeButton))
      }

      SSColor.gray100
        .frame(maxHeight: 24)
    }
    .background(SSColor.gray100)
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

      VStack {
        Spacer()
        makeNextScreenButton()
      }
      .ignoresSafeArea()
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
