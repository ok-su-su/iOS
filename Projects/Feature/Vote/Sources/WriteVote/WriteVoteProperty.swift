//
//  WriteVoteProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct WriteVoteProperty: Equatable {
  var selectedSection: VoteSectionHeaderItem = .wedding
  var voteTextContent: String = ""
  var selectableItem: [WriteVoteSelectableItem] = .default()
  
  mutating func addNewItem() {
    let nextID = selectableItem.count
    selectableItem.append(.init(id: nextID))
  }
  
  mutating func delete(item: WriteVoteSelectableItem) {
    selectableItem = selectableItem.filter{$0 != item}
  }
  
  /// 전체보기를 제외한 (결혼식, 장례식, 돌잔치, 생일기념일, 자유)
  var availableSection: [VoteSectionHeaderItem] {
    return VoteSectionHeaderItem.allCases.filter{$0 == .all}
  }
}


extension [WriteVoteSelectableItem] {
  static func `default`() -> Self { return (0..<2).map{.init(id: $0)} }
}

struct WriteVoteSelectableItem: VoteSelectableItem, Identifiable, Equatable {
  var content: String = ""
  var isEdited: Bool = false
  var isSaved: Bool = false
  var id: Int
  
  init(id: Int, content: String, isEdited: Bool, isSaved: Bool) {
    self.content = content
    self.isEdited = isEdited
    self.isSaved = isSaved
    self.id = id
  }
  init(id: Int) {
    self.id = id
  }
}

protocol VoteSelectableItem: Equatable {
  var content: String {get set}
}
