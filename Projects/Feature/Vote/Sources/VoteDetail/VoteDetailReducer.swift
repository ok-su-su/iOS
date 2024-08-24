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

// MARK: - VoteDetailReducer

@Reducer
struct VoteDetailReducer {
  @ObservableState
  struct State: Equatable {
    var id: Int64
    var isOnAppear = false
    var selectedVotedID: Int64? = nil
    var header: HeaderViewFeature.State = .init(.init(title: "결혼식", type: .depth2CustomIcon(.reportIcon)))
    ///    var helper: OtherVoteDetailProperty = .init()
    ///    var voteProgressBar: IdentifiedArrayOf<VoteProgressBarReducer.State> = []
    var isPresentAlert: Bool = false

    var voteDetailProperty: VoteDetailProperty? = nil
    var isLoading: Bool { voteDetailProperty == nil }
    var voteDetailProgressProperty: VoteDetailProgressProperty = .init(selectedVotedID: nil, items: [])

    init() {
      id = 12312
    }

    init(id: Int64) {
      self.id = id
    }
  }

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
    case showAlert(Bool)
    case tappedAlertConfirmButton(isChecked: Bool)
    case tappedVoteItem(id: Int64)
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.getVoteDetail))

    case let .showAlert(present):
      state.isPresentAlert = present
      return .none

    case let .tappedAlertConfirmButton(isChecked: _):
      // TODO: 신고 확인 버튼 눌렀을 때 적절한 API 사용
      return .run { _ in await dismiss() }

    case let .tappedVoteItem(id):
      // 만약 선택된 아이디가 없을 경우(첫 투표 일 경우)
      if state.selectedVotedID == nil {
        return .run { [boardID = state.id, optionID = id] send in
          try await network.executeVote(boardID, optionID)
          await send(.inner(.updateSelectedVotedItem(optionID: optionID)))
        }
        // 만약 선택된 아이디가 있는 경우(투표 덮어쓰기)
      } else if state.selectedVotedID != id {
        return .run { [boardID = state.id, optionID = id] send in
          try await network.overwriteVote(boardID, optionID)
          await send(.inner(.updateSelectedVotedItem(optionID: optionID)))
        }.throttle(id: CancelID.patchVote, for: 2, scheduler: RunLoop.main, latest: false)
        // 선택된 아이디를 다시 선택한 경우
      } else {
        return .none
      }
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
      state.selectedVotedID = optionID
      state.voteDetailProgressProperty.selectItem(optionID: optionID)
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case getVoteDetail
  }

  @Dependency(\.voteDetailNetwork) var network
  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getVoteDetail:
      return .run { [id = state.id] send in
        let responseProperty = try await network.voteDetail(id)
        await send(.inner(.updateVoteDetail(responseProperty)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedSearchButton):
      return .send(.view(.showAlert(true)))

    case .header:
      return .none
    }
  }

  enum DelegateAction: Equatable {}
  @Dependency(\.dismiss) var dismiss

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
