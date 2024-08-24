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
struct VotePathReducer {
  @ObservableState
  struct State: Equatable {
    var path: StackState<VotePathDestination.State> = .init()

    init() {}
  }

  enum Action: Equatable {
    case registerReducer
    case path(StackActionOf<VotePathDestination>)
    case push(VotePathDestination.State)
    case publisherAction(PublisherAction)
  }

  enum PublisherAction: Equatable {
    case updateVoteDetail(VoteDetailDeferNetworkRequest)
  }

  @Dependency(\.voteDetailNetwork) var voteDetailNetwork
  private func publisherAction(action: PublisherAction) -> Effect<Action> {
    switch action {
    case let .updateVoteDetail(property):
      let type = property.type
      let boardID = property.boardID
      // 선택된 아이디가 없기 때문에 return
      guard let optionID = property.optionID else {
        return .none
      }
      switch type {
      case .just: // 단일 투표
        return .run { _ in
          try await voteDetailNetwork.executeVote(boardID, optionID)
        }
      case .overwrite: // overwrite투표
        return .run { _ in
          try await voteDetailNetwork.overwriteVote(boardID, optionID)
        }
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
