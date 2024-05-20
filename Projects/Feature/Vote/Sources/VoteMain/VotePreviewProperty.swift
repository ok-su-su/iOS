//
//  VotePreviewProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - VotePreviewProperty

struct VotePreviewProperty: Equatable, Identifiable {
  var section: VoteSectionHeaderItem
  var content: String
  var id: Int
  var createdAt: Date
}

extension [VotePreviewProperty] {
  static func fakeData() -> Self {
    return (0 ..< 10).map { ind in
      .init(section: .birthDay, content: "ss", id: ind, createdAt: .now)
    }
  }
}
