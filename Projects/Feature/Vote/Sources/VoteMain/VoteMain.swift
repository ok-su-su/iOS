//
//  VoteMain.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
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
    fileprivate var taskManager: TaskManager = .init(taskCount: 3)
    fileprivate var hasNext: Bool = false
    fileprivate var currentPage: Int32 = 0

    fileprivate var voteRequestParam: GetVoteRequestQueryParameter {
      // 만약 InitialState 즉 전체를 선택할 경우에는 boardId를 0으로 해서 네트워크 통신블 보내야 합니다.
      let selectedBoardID = voteMainProperty.selectedVoteSectionItem != .initialState ? voteMainProperty.selectedVoteSectionItem?.id : nil
      return .init(
        content: nil,
        mine: voteMainProperty.onlyMineVoteFilter,
        sortType: voteMainProperty.sortByPopular ? .POPULAR : .LATEST,
        boardId: selectedBoardID,
        page: currentPage
      )
    }

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
    case tappedPopularSortButton
    case tappedOnlyMyPostButton
    case tappedFloatingButton
    // TODO: 어떤 아이템을 터치 했는지 정확하게...
    case tappedVoteItem
    case tappedReportButton(Int64)
    case tappedReportConfirmButton(isCheck: Bool)
    case presentReport(Bool)
    case voteItemOnAppear(VotePreviewProperty)
    case executeRefresh
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      state.isOnAppear = isAppear
      return .concatenate(
        .send(.inner(.isLoading(true))),
        .merge(
          .send(.async(.getPopularVoteItem)),
          .send(.async(.getInitialVoteItems)),
          .send(.async(.getVoteHeaderSectionItems))
        )
      )

    case let .tappedSectionItem(item):
      state.voteMainProperty.selectedVoteSectionItem = item
      return .send(.async(.getInitialVoteItems))

    case .tappedOnlyMyPostButton:
      state.voteMainProperty.onlyMineVoteFilter.toggle()
      return .send(.async(.getInitialVoteItems))

    case .tappedPopularSortButton:
      state.voteMainProperty.sortByPopular.toggle()
      return .send(.async(.getInitialVoteItems))

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

    case let .voteItemOnAppear(property):
      if state.voteMainProperty.votePreviews.last == property {
        return .send(.async(.getVoteItems)).throttle(id: CancelID.updateNextPage, for: 2, scheduler: RunLoop.main, latest: false)
      }
      return .none

    case .executeRefresh:
      return .send(.async(.getInitialVoteItems))
    }
  }

  enum CancelID {
    case checkIsLoading
    case updateNextPage
  }

  enum InnerAction: Equatable {
    case task(SingleTaskState)
    case present(VoteRouterInitialPath)
    case isLoading(Bool)
    case updatePopularItems([PopularVoteItem])
    case updateVoteItems(VoteNetworkResponse)
    case overwriteVoteItems(VoteNetworkResponse)
    case updateVoteHeaderCategory([VoteSectionHeaderItem])
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

    case let .updateVoteItems(property):
      state.hasNext = property.hasNext
      state.voteMainProperty.votePreviews = property.items
      dump(state.voteMainProperty.votePreviews.count)
      return .none

    case let .overwriteVoteItems(property):
      state.hasNext = property.hasNext
      state.voteMainProperty.votePreviews.overwriteByID(property.items)
      dump(state.voteMainProperty.votePreviews.count)
      return .none

    case let .updateVoteHeaderCategory(items):
      state.voteMainProperty.updateVoteSectionItems(items)
      return .none

    case let .task(taskState):
      switch taskState {
      case .willRun:
        state.taskManager.taskWillRun()
        return .none
      case .didFinish:
        state.taskManager.taskDidFinish()
        return state.taskManager.isRunningTask() ?
          .none :
          .send(.inner(.isLoading(false))).throttle(id: CancelID.checkIsLoading, for: 0.2, scheduler: RunLoop.main, latest: true)
      }
    }
  }

  @Dependency(\.voteMainNetwork) var network
  enum AsyncAction: Equatable {
    case getInitialVoteItems
    case getVoteItems
    case getPopularVoteItem
    case getVoteHeaderSectionItems
  }

  private func runWithVoteMutex(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable (Send<Action>) async throws -> Void,
    catch handler: (@Sendable (_ error: Error, _ send: Send<Action>) async -> Void)? = nil
  ) -> Effect<Action> {
    let startOperation: @Sendable (Send<Action>) async throws -> Void = { send in
      await send(.inner(.task(.willRun)))
    }
    let endOperation: @Sendable (Send<Action>) async throws -> Void = { send in
      await send(.inner(.task(.didFinish)))
    }
    return .runWithStartFinishAction(
      priority: priority,
      operation: operation,
      startOperation: startOperation,
      endOperation: endOperation,
      catch: handler
    )
  }

  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getInitialVoteItems:
      state.currentPage = 0
      state.hasNext = true
      let param = state.voteRequestParam
      state.currentPage = 1
      return runWithVoteMutex { send in
        let response = try await network.getVoteItems(param)
        await send(.inner(.updateVoteItems(response)))
      }

    case .getVoteItems:
      if !state.hasNext {
        return .none
      }
      let param = state.voteRequestParam
      state.currentPage += 1
      return runWithVoteMutex { send in
        let response = try await network.getVoteItems(param)
        await send(.inner(.overwriteVoteItems(response)))
      }

    case .getPopularVoteItem:
      return runWithVoteMutex { send in
        let items = try await network.getPopularItems()
        await send(.inner(.updatePopularItems(items)))
      }

    case .getVoteHeaderSectionItems:
      return runWithVoteMutex { send in
        let response = try await network.getVoteCategory()
        await send(.inner(.updateVoteHeaderCategory(response)))
      }
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
