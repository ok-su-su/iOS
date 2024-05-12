//
//  ProfileMainView.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct MyPageMainView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyPageMain>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView {
      VStack(spacing: 0) {
        VStack(spacing: 8) {
          makeMyNameAndMyInformationButtonView()
          makeTopSection()
          makeMiddleSection()
          makeBottomSection()
          Spacer()
        }
        Spacer()
          .frame(height: 16)

        makeAppVersionText()

        Spacer()
          .frame(height: 32)

        makeFeedbackButton()
      }
    }
  }

  @ViewBuilder
  private func makeTopSection() -> some View {
    VStack(spacing: 0) {
      ForEach(store.scope(state: \.topSectionList, action: \.scope.topSectionList)) { store in
        MyPageMainItemListCellView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeMiddleSection() -> some View {
    VStack(spacing: 0) {
      ForEach(store.scope(state: \.middleSectionList, action: \.scope.middleSectionList)) { store in
        MyPageMainItemListCellView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeBottomSection() -> some View {
    VStack(spacing: 0) {
      ForEach(store.scope(state: \.bottomSectionList, action: \.scope.bottomSectionList)) { store in
        MyPageMainItemListCellView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeAppVersionText() -> some View {
    Text("앱 버전 1.0.0")
      .modifier(SSTypoModifier(.title_xxxs))
      .foregroundStyle(SSColor.gray50)
  }

  @ViewBuilder
  private func makeFeedbackButton() -> some View {
    SSButton(
      .init(
        size: .sh40,
        status: .active,
        style: .ghost,
        color: .orange,
        buttonText: "수수에게 피드백 남기기"
      )) {
        store.send(.view(.tappedFeedbackButton))
      }
  }

  @ViewBuilder
  private func makeMyNameAndMyInformationButtonView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      Text("김수수") // TODO: logic 연결
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()

      HStack(alignment: .center, spacing: 8) {
        Text(Constants.myInformationText)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray60)

        SSImage
          .envelopeForwardArrow
      }
    }
    .padding(.vertical, Metrics.makeMyNameAndMyInformationButtonViewVerticalSpacing)
    .frame(maxWidth: .infinity)
    .background(SSColor.gray10)
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
        .blue50
        .ignoresSafeArea()

      SSColor
        .blue70

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .backgroundStyle(SSColor.orange50)
        Spacer()
        makeContentView()
      }
    }
//    .safeAreaInset(edge: .bottom) { makeTabBar() }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
  }

  private enum Metrics {
    static let makeMyNameAndMyInformationButtonViewVerticalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let myInformationText: String = "내정보"
  }
}
