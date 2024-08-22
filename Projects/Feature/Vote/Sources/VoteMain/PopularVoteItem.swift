//
//  PopularVoteItem.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PopularVoteItem

struct PopularVoteItem: Equatable, Identifiable {
  var id: Int64
  var categoryTitle: String
  var content: String
  var isActive: Bool
  var isModified: Bool
  var participantCount: Int64
}

extension [PopularVoteItem] {
  static func makeItem() -> Self {
    return (0 ..< 5).map { ind in
      return .init(
        id: ind,
        categoryTitle: fakeTitle,
        content: fakeContent,
        isActive: fakeBool,
        isModified: fakeBool,
        participantCount: fakeParticipantCount
      )
    }
  }

  private static var fakeTitle: String {
    let title = ["결혼식", "장례식", "생일파티", "생일잔치"]
    return title.randomElement()!
  }

  private static var fakeContent: String {
    let content = [
      "고등학교 동창이고 좀 애매하게 친한 사인데 축의금 얼마 내야 돼?",
      "지난봄, 어릴 때 만난 친구들 모임인 동창회에서 경조사 문제로 찬반 투표를 실시하였다. ",
      "혼식에 내는 봉투는 앞면에 '축결혼(祝結婚), 축화혼 ... 우리 학교 투표하면 간식차 온다. 잡코리",
      " 형제들 측은 “이러한 주주 의결안에 대한 투표는 직원들의 친목 및 경조사를 위한 모임인 사우회의 성격과 맞지 않는 것”으로",
    ]
    return content.randomElement()!
  }

  private static var fakeBool: Bool {
    return [false, true].randomElement()!
  }

  private static var fakeParticipantCount: Int64 {
    return (1 ... 50000).randomElement()!
  }
}
