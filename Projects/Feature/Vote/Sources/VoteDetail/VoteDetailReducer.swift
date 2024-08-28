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
import SSAlert
import SSNotification
import SSToast

// MARK: - VoteDetailReducer

@Reducer
struct VoteDetailReducer {
  @ObservableState
  struct State: Equatable {
    var id: Int64
    var isOnAppear = false
    var isPrevVoteID: Int64? = nil
    var selectedVotedID: Int64? = nil
    var header: HeaderViewFeature.State = .init(.init(title: "", type: .depth2CustomIcon(.reportIcon)))
    var presentReportAlert: Bool = false

    var participantsCount: Int64 {
      (selectedVotedID != nil ? 1 : 0) + (voteDetailProperty?.count ?? 0)
    }

    var voteDetailProperty: VoteDetailProperty? = nil
    var isLoading: Bool { voteDetailProperty == nil }
    var voteDetailProgressProperty: VoteDetailProgressProperty = .init(selectedVotedID: nil, items: [])
    var presentDeleteAlert: Bool = false
    var isRefreshVoteList: Bool = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: "누군가가 투표한 게시물은 수정할 수 없어요.", trailingType: .none))

    fileprivate var taskManager: TCAMutexManager = .init()

    init(id: Int64) {
      self.id = id
    }

    init(createdBoardID: Int64) {
      id = createdBoardID
      isRefreshVoteList = true
    }
  }

  @Dependency(\.dismiss) var dismiss

  enum CancelID {
    case patchVote
    case report
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
    case showReport(Bool)
    case showDeleteAlert(Bool)
    case tappedAlertConfirmButton(isChecked: Bool)
    case tappedVoteItem(id: Int64)
    case tappedDeleteConfirmButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.getVoteDetail))

    case let .showReport(present):
      state.presentReportAlert = present
      return .none

    case let .tappedAlertConfirmButton(isChecked):
      return .merge(
        .send(.async(.reportVote)),
        isChecked ? .send(.async(.blockUser)) : .none
      )

    case let .tappedVoteItem(id):
      return .send(.inner(.updateSelectedVotedItem(optionID: id)))

    case let .showDeleteAlert(val):
      state.presentDeleteAlert = val
      return .none

    case .tappedDeleteConfirmButton:
      return .send(.async(.deleteVote))
    }
  }

  enum InnerAction: Equatable {
    case updateVoteDetail(VoteDetailProperty)
    case updateSelectedVotedItem(optionID: Int64)
    case taskWithReport(SingleTaskState)
  }

  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .updateVoteDetail(property):

      // updateIsSelectedVoteProperty
      if let votedItem = property.options.filter(\.isVoted).first {
        state.selectedVotedID = votedItem.id
        state.isPrevVoteID = votedItem.id
      }

      // updateVoteDetailProgressBarProperty
      let items: [VoteDetailProgressBarProperty] = property.options.map { .init(id: $0.id, seq: $0.seq, title: $0.content, count: $0.count) }
      state.voteDetailProgressProperty = .init(selectedVotedID: state.selectedVotedID, items: items)
      // propertyUpdate
      state.voteDetailProperty = property

      let title = property.board.name
      let headerProperty = HeaderViewProperty(
        title: title,
        type: property.isMine ? .depth2DoubleText("편집", "삭제") : .depth2CustomIcon(.reportIcon)
      )
      return .send(.scope(.header(.updateProperty(headerProperty))))

    case let .updateSelectedVotedItem(optionID):
      let targetOptionID = optionID == state.selectedVotedID ? nil : optionID
      state.selectedVotedID = targetOptionID
      state.voteDetailProgressProperty.selectItem(optionID: targetOptionID)
      return .none

    case let .taskWithReport(taskState):
      switch taskState {
      case .willRun:
        state.taskManager.taskWillRun()
      case .didFinish:
        state.taskManager.taskDidFinish()
      }
      return state.taskManager.isRunningTask() ?
        .none :
        .run { _ in
          votePublisher.updateVoteList()
          await dismiss()
        }
        .debounce(id: CancelID.report, for: 0.4, scheduler: RunLoop.main)
    }
  }

  private func runWithVoteReportMutex(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable (Send<Action>) async throws -> Void,
    catch handler: (@Sendable (_ error: Error, _ send: Send<Action>) async -> Void)? = nil
  ) -> Effect<Action> {
    let startOperation: @Sendable (Send<Action>) async throws -> Void = { send in
      await send(.inner(.taskWithReport(.willRun)))
    }
    let endOperation: @Sendable (Send<Action>) async throws -> Void = { send in
      await send(.inner(.taskWithReport(.didFinish)))
    }
    return .runWithStartFinishAction(
      priority: priority,
      operation: operation,
      startOperation: startOperation,
      endOperation: endOperation,
      catch: handler
    )
  }

  enum AsyncAction: Equatable {
    case getVoteDetail
    case deleteVote
    case reportVote
    case blockUser
  }

  @Dependency(\.voteDetailNetwork) var network
  @Dependency(\.voteUpdatePublisher) var votePublisher
  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getVoteDetail:
      return .run { [id = state.id] send in
        let responseProperty = try await network.voteDetail(id)
        await send(.inner(.updateVoteDetail(responseProperty)))
      }

    case .deleteVote:
      return .run { [id = state.id] _ in
        try await network.deleteVote(id)
        votePublisher.deleteVote(ID: id)
        await dismiss()
      }

    case .reportVote:
      guard let boardID = state.voteDetailProperty?.id else {
        return .none
      }
      return runWithVoteReportMutex { _ in
        try await network.reportVote(boardID)
      }

    case .blockUser:
      guard let userID = state.voteDetailProperty?.creatorProfile.id else {
        return .none
      }
      return runWithVoteReportMutex { _ in
        try await network.blockUser(userID)
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case toast(SSToastReducer.Action)
  }

  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .header(.tappedSearchButton):
      return .send(.view(.showReport(true)))

    case .header(.tappedDoubleTextButton(.leading)):
      let isEditable = state.voteDetailProperty?.count == 0
      if !isEditable {
        return .send(.scope(.toast(.onAppear(true))))
      }
      if let voteDetailProperty = state.voteDetailProperty,
         let sectionHeaderItems: [VoteSectionHeaderItem] = VoteMemoryCache.value() {
        let voteEditInitialState: WriteVote.State = .init(
          voteId: voteDetailProperty.id,
          sectionHeaderItems: sectionHeaderItems,
          selectedHeaderItemID: Int(voteDetailProperty.board.id),
          content: voteDetailProperty.content,
          selectableItemsProperty: voteDetailProperty.options.map { .convertFromVoteOptionCountModel($0) }
        )
        VotePathPublisher.shared.push(.edit(voteEditInitialState))
      }
      return .none

    case .header(.tappedDoubleTextButton(.trailing)):
      return .send(.view(.showDeleteAlert(true)))

    case .header:
      return .none

    case .toast:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
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
