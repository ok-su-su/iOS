//
//  OtherVoteDetail.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import SSAlert

// MARK: - OtherVoteDetail

@Reducer
struct OtherVoteDetail {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "결혼식", type: .depth2CustomIcon(.reportIcon)))
    var helper: OtherVoteDetailProperty = .init()
    var voteProgressBar: IdentifiedArrayOf<VoteProgressBarReducer.State> = []
    var isPresentAlert: Bool = false

    init() {
      helper.voteProgress.forEach { property in
        guard let sharedProperty = helper.$voteProgress[id: property.id] else {
          return
        }
        voteProgressBar.append(.init(property: sharedProperty))
      }
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
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case voteProgressBar(IdentifiedActionOf<VoteProgressBarReducer>)
  }

  enum DelegateAction: Equatable {}
  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case .scope(.header(.tappedSearchButton)):
        return .send(.view(.showAlert(true)))

      case .scope(.header):
        return .none

      case let .scope(.voteProgressBar(.element(id: id, action: .tapped))):
        state.helper.voted(id: id)
        return .none

      case let .view(.showAlert(present)):
        state.isPresentAlert = present
        return .none
      case let .view(.tappedAlertConfirmButton(isChecked: _)):
        // TODO: 신고 확인 버튼 눌렀을 때 적절한 API사용

        return .run { _ in await dismiss() }
      }
    }
    .addFeatures()
  }
}

extension Reducer where State == OtherVoteDetail.State, Action == OtherVoteDetail.Action {
  func addFeatures() -> some ReducerOf<Self> {
    forEach(\.voteProgressBar, action: \.scope.voteProgressBar) {
      VoteProgressBarReducer()
    }
  }
}
