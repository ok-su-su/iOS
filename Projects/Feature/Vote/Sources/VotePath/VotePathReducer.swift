//
//  VotePathReducer.swift
//  Vote
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

@Reducer
struct VotePathReducer: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var path: StackState<VotePathDestination.State> = .init()

    init() {}
  }

  enum Action: Equatable, Sendable {
    case registerReducer
    case path(StackActionOf<VotePathDestination>)
    case push(VotePathDestination.State)
    case publisherAction(PublisherAction)
  }

  enum PublisherAction: Equatable, Sendable {
    case updateVoteDetail(VoteDetailDeferNetworkRequest)
  }

  @Dependency(\.voteDetailNetwork) var voteDetailNetwork
  private func publisherAction(action: PublisherAction) -> Effect<Action> {
    switch action {
    case let .updateVoteDetail(property):
      let type = property.type
      let boardID = property.boardID

      switch type {
      case let .just(optionID): // 단일 투표
        return .ssRun { _ in
          try await voteDetailNetwork.executeVote(boardID, optionID)
        }
      case let .overwrite(optionID): // overwrite투표
        return .ssRun { _ in
          try await voteDetailNetwork.overwriteVote(boardID, optionID)
        }
      case let .cancel(optionID):
        return .ssRun { _ in
          try await voteDetailNetwork.cancelVote(boardID, optionID)
        }
      case .none:
        return .none
      }
    }
  }

  private func sinkPublisherAndReducer() -> Effect<Action> {
    return .merge(
      .publisher {
        VotePathPublisher
          .shared
          .pathPublisher()
          .map { .push($0) }
      },
      .publisher {
        VoteDetailPublisher
          .disappearPublisher
          .map { .publisherAction(.updateVoteDetail($0)) }
      }
    )
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .registerReducer:
        return sinkPublisherAndReducer()
      case let .push(pathState):
        switch pathState {
        case .createVoteAndPushDetail:
          state.path.removeAll()
        default:
          break
        }
        state.path.append(pathState)
        return .none

      case .path:
        return .none
      case let .publisherAction(currentAction):
        return publisherAction(action: currentAction)
      }
    }
    .forEach(\.path, action: \.path)
  }
}
