//
//  VoteRouterPath.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - DismissVoteRouter

@Reducer
struct DismissVoteRouter {
  struct State: Equatable {}

  struct Action: Equatable {}

  var body: some ReducerOf<Self> {
    Reduce { _, _ in
      return .none
    }
  }
}

// MARK: - VoteRouterPath

@Reducer(state: .equatable, action: .equatable)
enum VoteRouterPath {
  case search(VoteSearch)
  case otherVoteDetail(OtherVoteDetail)
  case write(WriteVote)
  case myVote(MyVoteDetail)
  case edit(EditMyVote)
  case dismiss(DismissVoteRouter)
}
