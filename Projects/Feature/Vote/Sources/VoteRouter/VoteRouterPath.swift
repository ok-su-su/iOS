//
//  VoteRouterPath.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - VoteRouterPath

@Reducer(state: .equatable, action: .equatable)
enum VoteRouterPath {
  case search(VoteSearch)
  case otherVoteDetail(OtherVoteDetail)
  case write(WriteVote)
  case myVote(MyVoteDetail)
  case edit(EditMyVote)
}
