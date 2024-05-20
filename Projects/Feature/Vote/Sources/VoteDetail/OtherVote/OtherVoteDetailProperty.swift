//
//  OtherVoteDetailProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

struct OtherVoteDetailProperty: Equatable {
  @Shared var voteProgress: IdentifiedArrayOf<VoteProgressBarProperty>

  init() {
    _voteProgress = .init([])
    setFakeVoteProgress()
  }

  mutating func voted(id: Int) {
    let newItems = voteProgress.map { item in
      var item = item
      let progressValue = (1 ..< 100).randomElement()!
      item.showVoteProgressBarProperty = .init(
        progress: progressValue,
        showProgress: true,
        participantsCount: progressValue,
        isVoted: id == item.id
      )
      return item
    }
    voteProgress = .init(uniqueElements: newItems)
  }

  mutating func setFakeVoteProgress() {
    let sampleProperty = (0 ..< 5).map { ind in
      VoteProgressBarProperty(id: ind, title: (1 ..< 100).randomElement()!.description + "만원")
    }
    _voteProgress = .init(.init(uniqueElements: sampleProperty))
  }
}
