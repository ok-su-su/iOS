//
//  VotePathDestination.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - VotePathDestination

@Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
enum VotePathDestination {
  case search(VoteSearch)
  case write(WriteVote)
  case edit(WriteVote)
  case detail(VoteDetailReducer)
  case createVoteAndPushDetail(VoteDetailReducer)
}
