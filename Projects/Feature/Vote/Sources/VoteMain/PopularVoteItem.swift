//
//  PopularVoteItem.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PopularVoteItem

struct PopularVoteItem: Equatable, Identifiable, Sendable {
  var id: Int64
  var categoryTitle: String
  var content: String
  var isActive: Bool
  var isModified: Bool
  var participantCount: Int64
}
