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
import SSNotification
import SwiftUI

// MARK: - VoteDetailView

struct VoteDetailView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<VoteDetailReducer>
  @Dependency(\.voteUpdatePublisher) var voteUpdatePublisher

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
      isPresented: $store.presentReportAlert.sending(\.view.showReport),
      messageAlertProperty: .init(
        titleText: Constants.Report.reportAlertTitle,
        contentText: Constants.Report.reportAlertDescription,
        checkBoxMessage: .text(Constants.Report.checkBoxMessage),
        buttonMessage: .doubleButton(
          left: Constants.Report.reportAlertCancelText,
          right: Constants.Report.reportAlertConfirmText
        ),
        didTapCompletionButton: { isChecked in
          store.send(.view(.tappedAlertConfirmButton(isChecked: isChecked)))
        }
      )
    )
    .sSAlert(
      isPresented: $store.presentDeleteAlert.sending(\.view.showDeleteAlert),
      messageAlertProperty: .init(
        titleText: Constants.Delete.title,
        contentText: Constants.Delete.description,
        checkBoxMessage: .none,
        buttonMessage: .doubleButton(
          left: Constants.Delete.ConfirmText,
          right: Constants.Delete.ConfirmText
        )
      ) { _ in
        store.sendViewAction(.tappedDeleteConfirmButton)
      }
    )
    .onDisappear {
      callVoteAPI()
      updateVoteList()
    }
  }

  private enum Metrics {}

  private enum Constants {
    enum Report {
      static let reportAlertTitle = "해당 글을 신고할까요?"
      static let reportAlertDescription = """
      신고된 글은 수수의 확인 후 제재됩니다.\n이 작성자의 글을 더 이상 보고 싶지 않다면\n작성자를 바로 차단해 주세요.
      """
      static let reportAlertCancelText = "취소"
      static let reportAlertConfirmText = "신고하기"
      static let checkBoxMessage = "작성자도 바로 차단하기"
    }

    enum Delete {
      static let title = "투표를 삭제할까요?"
      static let description = """
      삭제한 투표는 다시 복구할 수 없어요.
      """
      static let cancelText = "취소"
      static let ConfirmText = "삭제"
    }
  }
}

extension VoteDetailView {
  private func callVoteAPI() {
    if let boardID = store.voteDetailProperty?.id {
      let type: VoteDetailDeferNetworkType
        // 선택한 투표가 존재한다면
        = if let selectedID = store.selectedVotedID {
        // 과거 투표와 현재 투표가 같을 경우 아무 작업도 하지 않스빈다.
        if selectedID == store.isPrevVoteID {
          .none
        }
        // 과거투표와 현재 투표가 같지 않으면서, 만약 과거 투표를 했다면 덮어쓰기 합니다.
        else if store.isPrevVoteID != nil {
          .overwrite(optionID: selectedID)
        }
        // 과거 투표를 하지 않았다면
        else {
          .just(optionID: selectedID)
        }
      } else {
        // 과거 투표를 했었다면 투표를 취소합니다.
        if let prevID = store.isPrevVoteID {
          .cancel(optionID: prevID)
        }
        // 과거 투표를 하지 않았고 현재도 투표하지 않았음으로 아무것도 하지 않습니다.
        else {
          .none
        }
      }

      VoteDetailPublisher
        .disappear(.init(boardID: boardID, type: type))
    }
  }

  private func updateVoteList() {
    if store.isRefreshVoteList {
      voteUpdatePublisher.updateVoteList()
    }
  }
}
