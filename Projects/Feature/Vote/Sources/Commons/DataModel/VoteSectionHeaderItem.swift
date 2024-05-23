//
//  VoteSectionHeaderItem.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SectionHeaderItem

enum VoteSectionHeaderItem: Int, Equatable, Identifiable, CaseIterable {
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
