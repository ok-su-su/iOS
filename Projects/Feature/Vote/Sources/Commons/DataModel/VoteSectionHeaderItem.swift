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

struct VoteSectionHeaderItem: Equatable, Identifiable {
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
