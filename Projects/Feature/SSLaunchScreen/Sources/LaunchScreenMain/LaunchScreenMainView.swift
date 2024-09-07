//
//  LaunchScreenMainView.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Designsystem
import SSAlert
import SwiftUI

// MARK: - LaunchScreenMainView

struct LaunchScreenMainView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<LaunchScreenMain>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {}
  }

  var body: some View {
    ZStack {
      SSColor
        .orange10
        .ignoresSafeArea()

      SSImage
        .commonLogo
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear(true))
    }
    .sSAlert(
      isPresented: $store.showMandatoryUpdateAlert.sending(\.mandatoryUpdateAlert),
      messageAlertProperty: .init(
        titleText: Constants.MandatoryUpdate.mandatoryUpdateTitle,
        contentText: Constants.MandatoryUpdate.mandatoryUpdateContent,
        checkBoxMessage: .none,
        buttonMessage: .singleButton(Constants.MandatoryUpdate.mandatoryUpdateButtonLabel),
        dismissWhenTappedButton: false,
        didTapCompletionButton: { _ in
          SSCommonRouting.openAppStore()
        }
      )
    )
  }

  private enum Metrics {}

  private enum Constants {
    enum MandatoryUpdate {
      static let mandatoryUpdateTitle: String = "업데이트가 필요해요"
      static let mandatoryUpdateContent: String = "새로운 버전의 수수를 다운로드해주세요"
      static let mandatoryUpdateButtonLabel: String = "스토어로 이동하기"
    }
  }
}
