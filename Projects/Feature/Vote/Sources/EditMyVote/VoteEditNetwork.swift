//
//  VoteEditNetwork.swift
//  Vote
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation

// MARK: - VoteEditNetwork

struct VoteEditNetwork {
  var getVoteCategory: @Sendable () async throws -> [VoteSectionHeaderItem]
}

// MARK: DependencyKey

extension VoteEditNetwork: DependencyKey {
  static let liveValue: VoteEditNetwork = .init(getVoteCategory: VoteMainNetwork.liveValue.getVoteCategory)
}

extension DependencyValues {
  var voteEditNetwork: VoteEditNetwork {
    get { self[VoteEditNetwork.self] }
    set { self[VoteEditNetwork.self] = newValue }
  }
}
