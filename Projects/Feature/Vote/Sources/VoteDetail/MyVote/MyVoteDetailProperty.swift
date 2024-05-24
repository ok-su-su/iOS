//
//  MyVoteDetailProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

struct MyVoteDetailProperty: Equatable {
  @Shared var voteProgress: IdentifiedArrayOf<VoteProgressBarProperty>
  init() {
    _voteProgress = .init([])
    setFakeVoteProgress()
  }

  mutating func setFakeVoteProgress() {
    let sampleProperty = (0 ..< 5).map { ind in
      let progressValue = (1 ..< 100).randomElement()!
      return VoteProgressBarProperty(
        id: ind,
        title: (1 ..< 100).randomElement()!.description + "만원",
        showVoteProgressBarProperty:
        .init(
          progress: progressValue,
          showProgress: true,
          participantsCount: progressValue,
          isVoted: false
        )
      )
    }
    _voteProgress = .init(.init(uniqueElements: sampleProperty))
  }
}
