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
    var isVoted: Bool = false
    var header: HeaderViewFeature.State = .init(.init(title: "결혼식", type: .depth2CustomIcon(.reportIcon)))
    ///    var helper: OtherVoteDetailProperty = .init()
    ///    var voteProgressBar: IdentifiedArrayOf<VoteProgressBarReducer.State> = []
    var isPresentAlert: Bool = false

    var voteDetailProperty: VoteDetailProperty? = nil
    var isLoading: Bool { voteDetailProperty == nil }

    init() {
      id = 12312
    }

    init(id: Int64) {
      self.id = id
    }
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
      return .none
    }
  }

  enum InnerAction: Equatable {
    case updateVoteDetail(VoteDetailProperty)
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .updateVoteDetail(property):
      state.voteDetailProperty = property

      let title = property.board.name
      let headerProperty = HeaderViewProperty(title: title, type: property.isMine ? .depth2DoubleText("편집", "삭제") : .depth2CustomIcon(.reportIcon))
      return .send(.scope(.header(.updateProperty(headerProperty))))
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
    case voteProgressBar(IdentifiedActionOf<VoteProgressBarReducer>)
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedSearchButton):
      return .send(.view(.showAlert(true)))

    case .header:
      return .none

    case let .voteProgressBar(.element(id: id, action: .tapped)):
//      state.helper.voted(id: id)
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
