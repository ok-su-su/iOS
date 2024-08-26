//
//  VotePreviewProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import CommonExtension
import Foundation

// MARK: - VotePreviewProperty

struct VotePreviewProperty: Equatable, Identifiable {
  var categoryTitle: String
  var content: String
  var id: Int64
  var createdAt: String
  var voteItemsTitle: [String]
  var participateCount: Int64
//  var createdAtLabel: String? {
//    guard let date = createdAt.fromISO8601ToDate() else {
//      return nil
//    }
//
//  }
}

extension VotePreviewProperty {
  var participateCountLabel: String {
    CustomNumberFormatter.formattedByThreeZero(participateCount, subFixString: "명 참여중") ?? ""
  }
}
