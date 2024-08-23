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
  var categoryTitle: String
  var content: String
  var id: Int64
  var createdAt: String
  var voteItemsTitle: [String]
}

extension [VotePreviewProperty] {
  static func fakeData() -> Self {
    return (0 ..< 10).map { ind in
      .init(categoryTitle: "하이용", content: "ss", id: ind, createdAt: "", voteItemsTitle: [])
    }
  }
}
