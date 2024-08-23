//
//  VoteMain.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSAlert

// MARK: - VoteMain

@Reducer
struct VoteMain {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(title: "투표", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .vote)
    var voteMainProperty = VoteMainProperty()
    var isPresentReport: Bool = false
    @Presents var voteRouter: VoteRouter.State? = nil

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
    case tappedSectionItem(VoteSectionHeaderItem)
    case tappedBottomVoteFilterType(BottomVoteListFilterItemType)
    case tappedFloatingButton
    // TODO: 어떤 아이템을 터치 했는지 정확하게...
    case tappedVoteItem
    case tappedReportButton(Int64)
    case tappedReportConfirmButton(isCheck: Bool)
    case presentReport(Bool)
  }

  enum InnerAction: Equatable {
    case present(VoteRouterInitialPath)
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
    case voteRouter(PresentationAction<VoteRouter.Action>)
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

      case .scope(.header(.tappedSearchButton)):
        state.voteRouter = .init(initialPath: .search)
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
        return .send(.inner(.present(.write)))

      case .view(.tappedVoteItem):
        return .send(.inner(.present(.voteDetail(Bool.random() ? .mine : .other))))

      case let .view(.tappedReportButton(id)):
        // TODO: 메시지 신고할 때 추가 로직 생성
        state.isPresentReport = true
        return .none
      case let .view(.tappedReportConfirmButton(idChecked)):
        // TODO: 신고 했을 때 로직 생성
        return .none
      case let .view(.presentReport(val)):
        state.isPresentReport = val
        return .none

      case .scope(.voteRouter):
        return .none

      case let .inner(.present(present)):
        state.voteRouter = .init(initialPath: present)
        return .none
      }
    }
    .addFeatures0()
  }
}

private extension Reducer where State == VoteMain.State, Action == VoteMain.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    ifLet(\.$voteRouter, action: \.scope.voteRouter) {
      VoteRouter()
    }
  }
}
