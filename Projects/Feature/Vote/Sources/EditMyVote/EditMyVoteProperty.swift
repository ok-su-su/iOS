//
//  EditMyVoteProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct EditMyVoteProperty: Equatable {
  var selectedSection: VoteSectionHeaderItem = .wedding
  var textFieldText: String = """
    고등학교 동창이고 좀 애매하게 친한 사인데 축의금 얼마 내야 돼?\n고등학교 동창이고 좀 애매하게 친한 사인데 축의금 얼마 내야 돼?
  """
  /// 전체보기를 제외한 (결혼식, 장례식, 돌잔치, 생일기념일, 자유)
  var availableSection: [VoteSectionHeaderItem] {
    return VoteSectionHeaderItem.allCases.filter { $0 != .all }
  }

  var voteItemProperties: [String] = [
    "3만원",
    "5만원",
    "10만원",
    "20만원",
    "30만원",
  ]

  init() {}
  init(selectedSection: VoteSectionHeaderItem) {
    self.selectedSection = selectedSection
  }
}
