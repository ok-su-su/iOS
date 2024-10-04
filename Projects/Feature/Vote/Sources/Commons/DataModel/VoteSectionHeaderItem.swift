//
//  VoteSectionHeaderItem.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork

// MARK: - VoteSectionHeaderItem

struct VoteSectionHeaderItem: Equatable, Identifiable, Sendable {
  var title: String
  var id: Int64
  var seq: Int32
  var isActive: Bool
}

extension BoardModel {
  func convertVoteSectionHeaderItem() -> VoteSectionHeaderItem {
    .init(title: name, id: id, seq: seq, isActive: isActive)
  }
}

extension VoteSectionHeaderItem {
  static var initialState: Self {
    .init(title: "전체", id: 0, seq: 0, isActive: true)
  }
}
