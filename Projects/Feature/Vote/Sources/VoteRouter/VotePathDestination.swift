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

@Reducer(state: .equatable, action: .equatable)
enum VotePathDestination {
  case search(VoteSearch)
  case otherVoteDetail(OtherVoteDetail)
  case write(WriteVote)
  case myVote(MyVoteDetail)
  case edit(EditMyVote)
}
