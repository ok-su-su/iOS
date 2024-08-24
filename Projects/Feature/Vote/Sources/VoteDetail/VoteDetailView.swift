//
//  VoteDetailView.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Designsystem
import SSAlert
import SwiftUI

struct VoteDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<OtherVoteDetail>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 16)

      VStack(alignment: .center, spacing: 24) {
        TopContentWithProfileAndText(property: .init(userImage: nil, userName: nil, userText: "고등학교 동창이고 좀 애매하게 친한 사인데 축의금 \n얼마 내야 돼?"))
          .padding(.horizontal, 16)

        VStack(alignment: .center, spacing: 16) {
          ParticipantsAndDateView(property: .init())

          ForEach(store.scope(state: \.voteProgressBar, action: \.scope.voteProgressBar)) { store in
            VoteProgressBar(store: store)
          }
        }
        .padding(.horizontal, 16)
      }

      Spacer()
    }
    .frame(maxWidth: .infinity)
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.view(.onAppear(true)))
    }
    .sSAlert(
      isPresented: $store.isPresentAlert.sending(\.view.showAlert),
      messageAlertProperty: .init(
        titleText: Constants.reportAlertTitle,
        contentText: Constants.reportAlertDescription,
        checkBoxMessage: .text(Constants.checkBoxMessage),
        buttonMessage: .doubleButton(
          left: Constants.reportAlertCancelText,
          right: Constants.reportAlertConfirmText
        ),
        didTapCompletionButton: { isChecked in
          store.send(.view(.tappedAlertConfirmButton(isChecked: isChecked)))
        }
      )
    )
  }

  private enum Metrics {}

  private enum Constants {
    static let reportAlertTitle = "해당 글을 신고할까요?"
    static let reportAlertDescription = """
    신고된 글은 수수의 확인 후 제재됩니다.\n이 작성자의 글을 더 이상 보고 싶지 않다면\n작성자를 바로 차단해 주세요.
    """
    static let reportAlertCancelText = "취소"
    static let reportAlertConfirmText = "신고하기"
    static let checkBoxMessage = "작성자도 바로 차단하기"
  }
}
