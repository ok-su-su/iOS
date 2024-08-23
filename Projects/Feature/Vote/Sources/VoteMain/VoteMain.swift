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
    var isLoading: Bool = true
    @Presents var voteRouter: VoteRouter.State? = nil

    fileprivate var isLastPage: Bool = false

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

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      state.isOnAppear = isAppear
      return .none

    case let .tappedSectionItem(item):
      state.voteMainProperty.selectedSectionHeaderItem = item
      return .none

    case let .tappedBottomVoteFilterType(type):
      state.voteMainProperty.setBottomFilter(type)
      return .none

    case .tappedFloatingButton:
      return .send(.inner(.present(.write)))

    case .tappedVoteItem:
      return .send(.inner(.present(.voteDetail(Bool.random() ? .mine : .other))))

    case let .tappedReportButton(id):
      // TODO: 메시지 신고할 때 추가 로직 생성
      state.isPresentReport = true
      return .none

    case let .tappedReportConfirmButton(isChecked):
      // TODO: 신고 했을 때 로직 생성
      return .none

    case let .presentReport(val):
      state.isPresentReport = val
      return .none
    }
  }

  enum InnerAction: Equatable {
    case present(VoteRouterInitialPath)
    case isLoading(Bool)
    case updatePopularItems([PopularVoteItem])
    case updateVoteItems([VotePreviewProperty])
    case overwriteVoteItems([VotePreviewProperty])
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .present(present):
      state.voteRouter = .init(initialPath: present)
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updatePopularItems(popularItems):
      state.voteMainProperty.favoriteVoteItems = popularItems
      return .none
    case let .updateVoteItems(items):
      state.voteMainProperty.votePreviews = items
      return .none
    case let .overwriteVoteItems(items):
      state.voteMainProperty.votePreviews.overwriteByID(items)
      return .none
    }
  }

  @Dependency(\.voteMainNetwork) var network
  enum AsyncAction: Equatable {
    case getInitialVoteItems
    case getVoteItems(GetVoteRequestQueryParameter)
    case getPopularVoteItem
  }

  func asyncAction(_: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getInitialVoteItems:
      return .run { send in
        let response = try await network.getPopularItems()

      }
    case let .getVoteItems(param):
      return .run { send in
        let response = try await network.getVoteItems(param)
      }
    case .getPopularVoteItem:
      return .none
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
    case voteRouter(PresentationAction<VoteRouter.Action>)
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .tabBar:
      return .none

    case .header(.tappedSearchButton):
      state.voteRouter = .init(initialPath: .search)
      return .none

    case .header:
      return .none

    case .voteRouter:
      return .none
    }
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
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
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

extension Array where Element: Identifiable{
  func overwritedByID(_ others: Self) -> Self{
    var mutatingSelf = self
    var indexDictionary: [Element.ID : Int] = [:]
    enumerated().forEach{indexDictionary[$0.element.id] = $0.offset}
    let notUpdateOthers = others.compactMap{ element -> Element? in
      if let index = indexDictionary[element.id] {
        mutatingSelf[index] = element
        return nil
      }
      return element
    }
    return mutatingSelf + notUpdateOthers
  }

  mutating func overwriteByID(_ others: Self){
    var indexDictionary: [Element.ID : Int] = [:]
    enumerated().forEach{indexDictionary[$0.element.id] = $0.offset}
    let notUpdateOthers = others.compactMap{ element -> Element? in
      if let index = indexDictionary[element.id] {
        self[index] = element
        return nil
      }
      return element
    }
    notUpdateOthers.forEach{append($0)}
  }

  subscript (safe index: Int) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
