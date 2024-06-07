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
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldTitleView

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()
        .frame(height: 34)

      // MARK: - TextFieldView

      SSTextFieldView(store: store.scope(state: \.textField, action: \.scope.textField))
      Spacer()
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeNextScreenButton() -> some View {
    SSButton(.init(
      size: .mh60,
      status: .active,
      style: .filled,
      color: .black,
      buttonText: "다음",
      frame: .init(maxWidth: .infinity)
    )) {
      store.send(.view(.tappedNextButton))
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
        Spacer()
        makeNextScreenButton()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private enum Constants {
    static let titleText = "반가워요!\n이름을 알려주세요"
  }
}
