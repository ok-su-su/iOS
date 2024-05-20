//
//  VoteMain.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

// MARK: - VoteMain

@Reducer
struct VoteMain {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(title: "투표", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .vote)
    var voteMainProperty = VoteMainProperty()
    @Presents var writeVote: WriteVote.State? = nil

    init() {}
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedSectionItem(VoteSectionHeaderItem)
    case tappedBottomVoteFilterType(BottomVoteListFilterItemType)
    case tappedFloatingButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
    case writeVote(PresentationAction<WriteVote.Action>)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .scope(.tabBar):
        return .none

      case .scope(.header):
        return .none

      case let .view(.tappedSectionItem(item)):
        state.voteMainProperty.selectedSectionHeaderItem = item
        return .none

      case let .view(.tappedBottomVoteFilterType(type)):
        state.voteMainProperty.setBottomFilter(type)
        return .none

      case .view(.tappedFloatingButton):
        state.writeVote = .init()
        return .none

      case .scope(.writeVote):
        return .none
      }
    }
    .addFeatures0()
  }
}

private extension Reducer where State == VoteMain.State, Action == VoteMain.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    ifLet(\.$writeVote, action: \.scope.writeVote) {
      WriteVote()
    }
  }
}
