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
  var favoriteVoteItems: [FavoriteVoteItem] = .makeItem()
  var selectedSectionHeaderItem: SectionHeaderItem = .all
  var selectedBottomFilterType: BottomVoteListFilterItemType = .none
  var votePreviews: [VotePreviewProperty] = .fakeData()

  mutating func setBottomFilter(_ item: BottomVoteListFilterItemType) {
    if selectedBottomFilterType == item {
      selectedBottomFilterType = .none
      return
    }
    selectedBottomFilterType = item
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

// MARK: - SectionHeaderItem

enum SectionHeaderItem: Int, Equatable, Identifiable, CaseIterable {
  /// 전체
  case all = 0
  /// 결혼식
  case wedding
  /// 장례식
  case funeral
  /// 돌잔치
  case doljanchi
  /// 생일 기념일
  case birthDay
  /// 자유
  case freeBoard
  var id: Int { return rawValue }

  var title: String {
    switch self {
    case .all:
      "전체"
    case .wedding:
      "결혼식"
    case .funeral:
      "장례식"
    case .doljanchi:
      "돌잔치"
    case .birthDay:
      "생일기념일"
    case .freeBoard:
      "자유"
    }
  }
}
