//
//  VoteDetailView.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import Foundation
import SSAlert
import SwiftUI

struct VoteDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<VoteDetailReducer>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {
    if let property = store.voteDetailProperty {
      makeVoteDetailContentView(property)
    } else {
      makeLoadingView()
    }
  }

  @ViewBuilder
  private func makeVoteDetailContentView(_ property: VoteDetailProperty) -> some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 16)

      VStack(alignment: .center, spacing: 24) {
        TopContentWithProfileAndText(
          property: .init(
            userImage: nil,
            userName: property.creatorProfile.name,
            userText: property.content
          )
        )
        .padding(.horizontal, 16)

        ParticipantsAndDateView(
          property: .init(participantsCount: property.count, createdDateLabel: property.createdAtLabel)
        )
        .padding(.horizontal, 16)

        VoteDetailProgressView(property: store.voteDetailProgressProperty) { id in
          store.sendViewAction(.tappedVoteItem(id: id))
        }
        .padding(.horizontal, 16)
      }

      Spacer()
    }
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func makeLoadingView() -> some View {
    Color.clear
  }

  var body: some View {
    ZStack {
      SSColor
        .gray10
        .ignoresSafeArea()
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.header, action: \.scope.header))
        makeContentView()
          .ssLoading(store.isLoading)
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
    .onDisappear {
      if let boardID = store.voteDetailProperty?.id {
        let type: VoteDetailDeferNetworkType = store.isPrevVoteID == nil ? .just : .overwrite
        let optionID = store.selectedVotedID == store.isPrevVoteID ? nil : store.selectedVotedID

        VoteDetailPublisher
          .disappear(.init(boardID: boardID, optionID: optionID, type: type))
      }
    }
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
