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
    Text("동의하기")
      .applySSFont(.title_xs)
      .foregroundStyle(SSColor.gray10)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .background(SSColor.gray100)
      .onTapGesture {
        store.send(.view(.tappedAgreeButton))
      }
  }

  var body: some View {
    ZStack {
      SSColor
        .gray15
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .padding(.bottom, 9)
      }
      .safeAreaInset(edge: .bottom) {
        makeNextScreenButton()
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
