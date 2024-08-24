//
//  VoteMainProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - VoteMainProperty

struct VoteMainProperty: Equatable {
  var favoriteVoteItems: [PopularVoteItem] = []
  var selectedVoteSectionItem: VoteSectionHeaderItem? = .initialState
  var voteSectionItems: [VoteSectionHeaderItem] = [.initialState]
  var onlyMineVoteFilter: Bool = false
  var sortByPopular: Bool = false
  var votePreviews: [VotePreviewProperty] = []

  mutating func updateVoteSectionItems(_ items: [VoteSectionHeaderItem]) {
    items.forEach { voteSectionItems.append($0) }
  }
}
