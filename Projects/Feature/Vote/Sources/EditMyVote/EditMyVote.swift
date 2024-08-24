//
//  EditMyVote.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation

// MARK: - EditMyVote

@Reducer
struct EditMyVote {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var helper: EditMyVoteProperty = .init(selectedSection: .init(title: "", id: 22, seq: 3, isActive: true))
    var header: HeaderViewFeature.State = .init(.init(title: "투표 편집", type: .depth2Text("등록")))
    init() {}
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
    case editedVoteTextContent(String)
    case tappedSection(VoteSectionHeaderItem)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    initScope
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case let .view(.editedVoteTextContent(text)):
        state.helper.textFieldText = text
        return .none
      case let .view(.tappedSection(item)):
        state.helper.selectedSection = item
        return .none
      case .scope(.header(.tappedTextButton)):
//        VotePathPublisher.shared.push(.myVote(.init()))
        return .none
      case .scope(.header):
        return .none
      }
    }
  }
}

extension Reducer where State == EditMyVote.State, Action == EditMyVote.Action {
  var initScope: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
  }
}
