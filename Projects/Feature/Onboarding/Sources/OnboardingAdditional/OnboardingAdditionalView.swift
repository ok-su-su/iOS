//
//  OnboardingAdditionalView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSBottomSelectSheet
import SwiftUI

struct OnboardingAdditionalView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OnboardingAdditional>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 24)

      Text(Constants.titleText)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)

      Spacer()
        .frame(height: 32)

      VStack(spacing: 24) {
        makeGenderSection()
        makeBirthSection()
      }
      Spacer()
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private func makeGenderSection() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(Constants.genderSectionTitleText)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)
        .multilineTextAlignment(.leading)

      HStack(spacing: 8) {
        ForEach(store.helper.genderItems) { item in
          makeGenderSectionItem(item)
        }
      }
    }
  }

  @ViewBuilder
  private func makeGenderSectionItem(_ item: GenderType) -> some View {
    SSButton(
      .init(
        size: .mh60,
        status: store.helper.selectedGenderItem == item ? .active : .inactive,
        style: .ghost,
        color: .black,
        buttonText: item.title,
        frame: .init(maxWidth: .infinity)
      )
    ) {
      store.send(.view(.tappedGenderButton(item)))
    }
  }

  @ViewBuilder
  private func makeBirthSection() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(Constants.birthSectionTitleText)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.gray60)
        .multilineTextAlignment(.leading)

      SSButton(
        .init(
          size: .mh60,
          status: store.helper.selectedBirth == nil ? .inactive : .active,
          style: .ghost,
          color: .black,
          buttonText: store.helper.selectedBirth?.description ?? makeNowYear(),
          frame: .init(maxWidth: .infinity)
        )
      ) {
        store.send(.view(.tappedBirthButton))
      }
    }
  }

  @ViewBuilder
  private func makeNextScreenButton() -> some View {
    Text("다음")
      .applySSFont(.title_xs)
      .foregroundStyle(SSColor.gray10)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .background(SSColor.gray100)
      .onTapGesture {
        store.sendViewAction(.tappedNextButton)
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
      }
    }
    .navigationBarBackButtonHidden()
    .safeAreaInset(edge: .bottom) {
      makeNextScreenButton()
    }
    .ssLoading(store.isLoading)
    .selectableBottomSheetWithBottomView(
      store: $store.scope(state: \.bottomSheet, action: \.scope.bottomSheet),
      cellCount: 6,
      availableFullScreenMode: true
    ) {
      makeNextScreenButton()
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {}

  private func makeNowYear() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: .now) + "년"
  }

  private enum Constants {
    static let titleText: String = "아래 정보들을 알려주시면\n통계를 알려드릴 수 있어요"
    static let genderSectionTitleText: String = "성별"
    static let birthSectionTitleText: String = "출생년도"
  }
}
