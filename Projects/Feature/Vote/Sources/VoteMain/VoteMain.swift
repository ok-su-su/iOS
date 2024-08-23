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
      return .run { send in
        await send(.inner(.isLoading(true)))
        await withTaskGroup(of: Void.self) { group in
          group.addTask {
            await send(.async(.getPopularVoteItem))
            await send(.async(.getInitialVoteItems))
            await send(.async(.getVoteHeaderSectionItems))
          }
        }
      }

    case let .tappedSectionItem(item):
      state.voteMainProperty.selectedVoteSectionItem = item
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

  enum CancelID {
    case checkIsLoading
  }

  enum InnerAction: Equatable {
    case task(SingleTaskState)
    case present(VoteRouterInitialPath)
    case isLoading(Bool)
    case updatePopularItems([PopularVoteItem])
    case updateVoteItems([VotePreviewProperty])
    case overwriteVoteItems([VotePreviewProperty])
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
    case let .updateVoteItems(items):
      state.voteMainProperty.votePreviews = items
      return .none

    case let .overwriteVoteItems(items):
      state.voteMainProperty.votePreviews.overwriteByID(items)
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
    case getVoteItems(GetVoteRequestQueryParameter)
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

  func asyncAction(_: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getInitialVoteItems:
      return runWithVoteMutex { send in
        let items = try await network.getPopularItems()
        await send(.inner(.updatePopularItems(items)))
      }

    case let .getVoteItems(param):
      return runWithVoteMutex { send in
        let response = try await network.getVoteItems(param)
        await send(.inner(.overwriteVoteItems(response.items)))
        // TODO: Page UpdateLogic 및 다양한 로직 세우기
      }

    case .getPopularVoteItem:
      return runWithVoteMutex { send in
        let response = try await network.getInitialVoteItems()
        await send(.inner(.updateVoteItems(response.items)))
        // TODO: Page UpdateLogic 및 다양한 로직 세우기
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
