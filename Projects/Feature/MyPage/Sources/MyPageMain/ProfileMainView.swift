//
//  ProfileMainView.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SafariServices
import SSAlert
import SSToast
import SwiftUI

// MARK: - MyPageMainView

struct MyPageMainView: View {
  @Environment(\.openURL) private var openURL

  // MARK: Reducer

  @Bindable
  var store: StoreOf<MyPageMain>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    ScrollView {
      VStack(spacing: 0) {
        VStack(spacing: 8) {
          makeTopSection()
          makeMiddleSection()
          makeBottomSection()
        }
        makeAppVersionText()
          .padding(.leading, 15)
          .padding(.top, 16)
          .padding(.bottom, 32)
        makeFeedbackButton()
      }
    }
    .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
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
    // TODO: Some Logic
    HStack {
      let appVersion = store.currentVersionText
      Text("앱 버전 \(appVersion)")
        .modifier(SSTypoModifier(.title_xxxs))
        .foregroundStyle(SSColor.gray50)
      Spacer()
    }
  }

  @ViewBuilder
  private func makeFeedbackButton() -> some View {
    SSButton(
      .init(
        size: .sh40,
        status: .active,
        style: .ghost,
        color: .orange,
        buttonText: Constants.feedbackButtonText
      )) {
        store.send(.view(.tappedFeedbackButton))
      }
      .frame(alignment: .center)
  }

  @ViewBuilder
  private func makeMyNameAndMyInformationButtonView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      Text(store.userInfo.name)
        .modifier(SSTypoModifier(.title_m))
        .foregroundStyle(SSColor.gray100)

      Spacer()

      HStack(alignment: .center, spacing: 8) {
        Text(Constants.myInformationText)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray60)

        SSImage
          .commonForwardArrow
          .resizable()
          .frame(width: 16, height: 16)
      }
    }
    .padding(.horizontal, Metrics.horizontalSpacing)
    .padding(.vertical, Metrics.makeMyNameAndMyInformationButtonViewVerticalSpacing)
    .frame(maxWidth: .infinity)
    .background(SSColor.gray10)
    .contentShape(Rectangle())
    .onTapGesture {
      store.send(.view(.tappedMyPageInformationSection))
    }
  }

  @ViewBuilder
  private func makeNavigationStackView(
    @ViewBuilder root: () -> some View
  ) -> some View {
    NavigationStack(path: $store.scope(state: \.pathState.path, action: \.scope.pathAction.path)) {
      root()
    } destination: { store in
      switch store.case {
      case let .myPageInfo(store):
        MyPageInformationView(store: store)
      case let .editMyPage(store):
        MyPageEditView(store: store)
      }
    }
  }

  @ViewBuilder
  private func makeMyPageRootView() -> some View {
    ZStack {
      SSColor
        .gray20
        .ignoresSafeArea()

      VStack {
        SSColor
          .gray10
          .frame(maxWidth: .infinity, maxHeight: 60)

        Spacer()
      }

      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
          .background(SSColor.gray10)
        Spacer()
        makeMyNameAndMyInformationButtonView()
        makeContentView()
          .modifier(SSLoadingModifier(isLoading: store.isLoading))
      }
    }
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .fullScreenCover(
      isPresented: $store.pathState.presentPrivacyPolicy.sending(\.scope.pathAction.present.presentPrivacyPolicy)
    ) {
      if let privacyURLString = Constants.privacyURLString,
         let url = URL(string: privacyURLString) {
        SafariWebView(url: url)
      }
    }
    .fullScreenCover(
      isPresented: $store.pathState.presentFeedBack.sending(\.scope.pathAction.present.presentFeedBack)) {
        if let feedBackString = Constants.feedBackURLString,
           let url = URL(string: feedBackString) {
          SafariWebView(url: url)
        }
    }
  }

  var body: some View {
    makeNavigationStackView {
      makeMyPageRootView()
    }
    .addSSTabBar(store.scope(state: \.tabBar, action: \.scope.tabBar))
    .sSAlert(
      isPresented: $store.pathState.presentLogoutAlert.sending(\.scope.pathAction.present.presentLogoutAlert),
      messageAlertProperty: .init(
        titleText: "로그아웃 할까요?",
        contentText: "",
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(left: "취소", right: "로그아웃"),
        didTapCompletionButton: { _ in
          store.sendViewAction(.tappedLogOut)
        }
      )
    )
    .sSAlert(
      isPresented: $store.pathState.presentResignAlert.sending(\.scope.pathAction.present.presentResignAlert),
      messageAlertProperty: .init(
        titleText: "정말 탈퇴하시겠어요?",
        contentText: "계정 정보와 모든 기록이 삭제되며 다시 복구할 수 없어요",
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(left: "취소", right: "탈퇴"),
        didTapCompletionButton: { _ in
          store.sendViewAction(.tappedResignButton)
        }
      )
    )
  }

  private enum Metrics {
    static let makeMyNameAndMyInformationButtonViewVerticalSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 16
  }

  private enum Constants {
    static let myInformationText: String = "내정보"
    static let feedbackButtonText: String = "수수에게 피드백 남기기"

    static let privacyURLString: String? = Bundle(for: BundleFinder.self).infoDictionary?["PRIVACY_POLICY_URL"] as? String

    static let feedBackURLString: String? = Bundle(for: BundleFinder.self).infoDictionary?["SUSU_GOOGLE_FROM_URL"] as? String
  }
}

// MARK: - BundleFinder

private class BundleFinder {}
