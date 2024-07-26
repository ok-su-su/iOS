//
//  ProfileMainView.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SSAlert
import SSToast
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
    .onTapGesture {
      store.send(.route(.myPageInformation))
    }
  }

  var body: some View {
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
    .addSSTabBar(store.scope(state: \.tabBar, action: \.scope.tabBar))
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .sSAlert(
      isPresented: $store.showMessageAlert.sending(\.view.showAlert),
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
      isPresented: $store.showResignAlert.sending(\.view.showResignAlert),
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
  }
}
