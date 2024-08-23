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
  var favoriteVoteItems: [PopularVoteItem] = .makeItem()
  var selectedVoteSectionItem: VoteSectionHeaderItem? = nil
  var voteSectionItems: [VoteSectionHeaderItem] = []
  var selectedBottomFilterType: BottomVoteListFilterItemType = .none
  var votePreviews: [VotePreviewProperty] = []

  mutating func setBottomFilter(_ item: BottomVoteListFilterItemType) {
    if selectedBottomFilterType == item {
      selectedBottomFilterType = .none
      return
    }
    selectedBottomFilterType = item
  }

  mutating func updateVoteSectionItems(_ items: [VoteSectionHeaderItem]) {
    voteSectionItems = items
    if let firstItem = items.first {
      selectedVoteSectionItem = firstItem
    }
  }
}

// MARK: - BottomVoteListFilterItemType

enum BottomVoteListFilterItemType: Equatable {
  /// 아무것도 선택하지 않음
  case none
  /// 투표 많은 순
  case mostVote
  /// 내 글
  case myBoard
}
