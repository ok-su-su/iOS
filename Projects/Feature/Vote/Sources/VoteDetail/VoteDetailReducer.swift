//
//  VoteDetailReducer.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSAlert
import SSNotification

// MARK: - VoteDetailReducer

@Reducer
struct VoteDetailReducer {
  @ObservableState
  struct State: Equatable {
    var id: Int64
    var isOnAppear = false
    var isPrevVoteID: Int64? = nil
    var selectedVotedID: Int64? = nil
    var header: HeaderViewFeature.State = .init(.init(title: "결혼식", type: .depth2CustomIcon(.reportIcon)))
    var presentReportAlert: Bool = false

    var voteDetailProperty: VoteDetailProperty? = nil
    var isLoading: Bool { voteDetailProperty == nil }
    var voteDetailProgressProperty: VoteDetailProgressProperty = .init(selectedVotedID: nil, items: [])
    var presentDeleteAlert: Bool = false
    var isRefreshVoteList: Bool = false

    init(id: Int64) {
      self.id = id
    }

    init(createdBoardID: Int64) {
      id = createdBoardID
      isRefreshVoteList = true
    }
  }

  @Dependency(\.dismiss) var dismiss

  enum CancelID {
    case patchVote
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case showReport(Bool)
    case showDeleteAlert(Bool)
    case tappedAlertConfirmButton(isChecked: Bool)
    case tappedVoteItem(id: Int64)
    case tappedDeleteConfirmButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.getVoteDetail))

    case let .showReport(present):
      state.presentReportAlert = present
      return .none

    case let .tappedAlertConfirmButton(isChecked: _):
      // TODO: 신고 확인 버튼 눌렀을 때 적절한 API 사용
      return .run { _ in await dismiss() }

    case let .tappedVoteItem(id):
      // 만약 선택된 아이디가 없을 경우(첫 투표 일 경우)
      return .send(.inner(.updateSelectedVotedItem(optionID: id)))
    case let .showDeleteAlert(val):
      state.presentDeleteAlert = val
      return .none

    case .tappedDeleteConfirmButton:
      return .send(.async(.deleteVote))
    }
  }

  enum InnerAction: Equatable {
    case updateVoteDetail(VoteDetailProperty)
    case updateSelectedVotedItem(optionID: Int64)
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .updateVoteDetail(property):

      // updateIsSelectedVoteProperty
      if let votedItem = property.options.filter(\.isVoted).first {
        state.selectedVotedID = votedItem.id
        state.isPrevVoteID = votedItem.id
      }

      // updateVoteDetailProgressBarProperty
      let items: [VoteDetailProgressBarProperty] = property.options.map { .init(id: $0.id, seq: $0.seq, title: $0.content, count: $0.count) }
      state.voteDetailProgressProperty = .init(selectedVotedID: state.selectedVotedID, items: items)
      // propertyUpdate
      state.voteDetailProperty = property

      let title = property.board.name
      let headerProperty = HeaderViewProperty(title: title, type: property.isMine ? .depth2DoubleText("편집", "삭제") : .depth2CustomIcon(.reportIcon))
      return .send(.scope(.header(.updateProperty(headerProperty))))

    case let .updateSelectedVotedItem(optionID):
      let targetOptionID = optionID == state.selectedVotedID ? nil : optionID
      state.selectedVotedID = targetOptionID
      state.voteDetailProgressProperty.selectItem(optionID: targetOptionID)
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case getVoteDetail
    case deleteVote
  }

  @Dependency(\.voteDetailNetwork) var network
  @Dependency(\.voteUpdatePublisher) var votePublisher
  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getVoteDetail:
      return .run { [id = state.id] send in
        let responseProperty = try await network.voteDetail(id)
        await send(.inner(.updateVoteDetail(responseProperty)))
      }
    case .deleteVote:
      return .run { [id = state.id] _ in
        try await network.deleteVote(id)
        votePublisher.deleteVote(ID: id)
        await dismiss()
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedSearchButton):
      return .send(.view(.showReport(true)))

    case .header(.tappedDoubleTextButton(.leading)):

      if let voteDetailProperty = state.voteDetailProperty {
        VotePathPublisher.shared.push(.edit(.init(voteDetailProperty: voteDetailProperty)))
      }
      return .none

    case .header(.tappedDoubleTextButton(.trailing)):
      return .send(.view(.showDeleteAlert(true)))

    case .header:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      }
    }
//    .addFeatures()
  }
}

extension Reducer where State == VoteDetailReducer.State, Action == VoteDetailReducer.Action {
//  func addFeatures() -> some ReducerOf<Self> {
//    forEach(\.voteProgressBar, action: \.scope.voteProgressBar) {
//      VoteProgressBarReducer()
//    }
//  }
}
