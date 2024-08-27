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

    fileprivate var votePath: VotePathReducer.State = .init()
    var path: StackState<VotePathDestination.State> {
      votePath.path
    }

    fileprivate var taskManager: TCAMutexManager = .init(taskCount: 3)
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
    case tappedVoteItem(id: Int64)
    case tappedReportButton(Int64)
    case tappedReportConfirmButton(isCheck: Bool)
    case presentReport(Bool)
    case voteItemOnAppear(VotePreviewProperty)
    case executeRefresh
  }

  private func registerVoteReducer() -> Effect<Action> {
    return .merge(
      .send(.scope(.votePath(.registerReducer))),
      .publisher {
        votePublisher
          .deleteVotePublisher
          .map { .inner(.deleteVote($0)) }
      },
      .publisher {
        votePublisher
          .updateVoteListPublisher
          .map { .async(.getInitialVoteItems) }
      }
    )
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .concatenate(
        .send(.scope(.votePath(.registerReducer))),
        .send(.inner(.isLoading(true))),
        .merge(
          .send(.async(.getPopularVoteItems)),
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
      let items = state.voteMainProperty.voteSectionItems
      VotePathPublisher.shared.push(.write(.init(sectionHeaderItems: items)))
      return .none

    case let .tappedVoteItem(id):
      VotePathPublisher.shared.push(.detail(.init(id: id)))
      return .none

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
    case isLoading(Bool)
    case updatePopularItems([PopularVoteItem])
    case updateVoteItems(VoteNetworkResponse)
    case overwriteVoteItems(VoteNetworkResponse)
    case updateVoteHeaderCategory([VoteSectionHeaderItem])
    case deleteVote(Int64)
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updatePopularItems(popularItems):
      state.voteMainProperty.favoriteVoteItems = popularItems
      return .none

    case let .updateVoteItems(property):
      state.hasNext = property.hasNext
      state.voteMainProperty.votePreviews = property.items
      return .none

    case let .overwriteVoteItems(property):
      state.hasNext = property.hasNext
      state.voteMainProperty.votePreviews.overwriteByID(property.items)
      return .none

    case let .updateVoteHeaderCategory(items):
      state.voteMainProperty.updateVoteSectionItems(items)
      return .none

    case let .deleteVote(id):
      state.voteMainProperty.votePreviews.removeAll(where: { $0.id == id })
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
  @Dependency(\.voteUpdatePublisher) var votePublisher
  enum AsyncAction: Equatable {
    case getInitialVoteItems // initial상태의 투표 아이템을 불러옵니다.
    case getVoteItems // 더이상 보여줄 아이템이 없다면 새 아이템을 불러옵니다.
    case getPopularVoteItems // 인기 투표 아이템을 불러옵니다.
    case getVoteHeaderSectionItems // 헤더 섹션 아이템을 가져 옵니다.
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

    case .getPopularVoteItems:
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
    case votePath(VotePathReducer.Action)
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
  }

  func scopeAction(_: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .votePath:
      return .none

    case .tabBar:
      return .none

    case .header(.tappedSearchButton):
      VotePathPublisher.shared.push(.search(.init()))
      return .none

    case .header:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.votePath, action: \.scope.votePath) {
      VotePathReducer()
    }

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
  }
}

private extension Reducer where State == VoteMain.State, Action == VoteMain.Action {}
