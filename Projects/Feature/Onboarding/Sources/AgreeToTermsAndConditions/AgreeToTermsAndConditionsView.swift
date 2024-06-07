//
//  AgreeToTermsAndConditionsView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct AgreeToTermsAndConditionsView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<AgreeToTermsAndConditions>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)
        .padding(.vertical, 24)
        .multilineTextAlignment(.leading)

      makeTermsAndConditions()
      Spacer()
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeNextScreenButton() -> some View {
    VStack(spacing: 0) {
      SSButton(.init(
        size: .mh60,
        status: store.helper.activeNextScreenButton ? .active : .inactive,
        style: .filled,
        color: .black,
        buttonText: "다음",
        frame: .init(maxWidth: .infinity)
      )) {
        store.send(.view(.tappedNextScreenButton))
      }
      .allowsHitTesting(store.helper.activeNextScreenButton)

      Color.clear
        .frame(maxHeight: 24)
    }
    .background(store.helper.activeNextScreenButton ? SSColor.gray100 : SSColor.gray30)
  }

  @ViewBuilder
  private func makeTermsAndConditions() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      // 전체 동의
      HStack(spacing: 0) {
        (store.helper.isAllCheckedItems ? SSImage.commonCheckBox : SSImage.commonUnCheckBox)
          .onTapGesture {
            store.send(.view(.checkAllTerms))
          }

        Spacer()
          .frame(width: 16)

        Text(Constants.checkAllTermsText)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray100)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 16)

      SSColor
        .gray30
        .frame(minHeight: 1, maxHeight: 1)

      ForEach(store.helper.termItems) { item in
        makeTermsAndConditionsItem(item)
      }
    }
  }

  @ViewBuilder
  private func makeTermsAndConditionsItem(_ item: TermItem) -> some View {
    HStack(spacing: 0) {
      (item.isCheck ? SSImage.commonCheckBox : SSImage.commonUnCheckBox)
        .onTapGesture {
          store.send(.view(.tappedCheckBox(item)))
        }

      Spacer()
        .frame(width: 16)

      SmallBadge(property: SmallBadgeProperty(
        size: .small,
        badgeString: item.isEssential ? Constants.essentialBadgeText : Constants.optionalBadgeText,
        badgeColor: item.isEssential ? .blue60 : .gray30
      ))

      Spacer()
        .frame(width: 8)

      Text(item.title)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray100)

      Spacer()

      if item.isDetailContent {
        SSImage
          .commonArrow
          .rotationEffect(.radians(Double.pi))
          .onTapGesture {
            store.send(.view(.tappedTermDetailButton(item)))
          }
      }
    }
    .padding(.vertical, 16)
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

  private enum Constants {
    static let titleText: String = "서비스 사용을 위해\n약관에 동의해주세요"
    static let checkAllTermsText: String = "전체 동의하기"

    static let essentialBadgeText: String = "필수"
    static let optionalBadgeText: String = "선택"
  }
}
