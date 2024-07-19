//
//  OnboardingRegisterNameView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct OnboardingRegisterNameView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OnboardingRegisterName>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 24) {
      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      // MARK: - TextFieldView

      SSTextFieldView(store: store.scope(state: \.textField, action: \.scope.textField))
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeNextScreenButton() -> some View {
    Text("다음")
      .applySSFont(.title_xs)
      .foregroundStyle(SSColor.gray10)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .background(store.isActiveNextButton ? SSColor.gray100 : SSColor.gray30)
      .allowsHitTesting(store.isActiveNextButton)
      .onTapGesture {
        store.sendViewAction(.tappedNextButton)
      }
  }

  var body: some View {
    ZStack(alignment: .top) {
      SSColor
        .gray15
        .ignoresSafeArea()
        .whenTapDismissKeyboard()

      VStack(spacing: 34) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) {
      makeNextScreenButton()
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let titleText = "반가워요!\n닉네임을 알려주세요"
  }
}
