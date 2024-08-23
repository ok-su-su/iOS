//
//  WriteVoteProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - WriteVoteProperty

struct WriteVoteProperty: Equatable {
  var selectedSection: VoteSectionHeaderItem = .init(title: "", id: 33, seq: 2, isActive: true)
  var voteTextContent: String = ""
  var selectableItemID: Int = 0
  @Shared var selectableItem: IdentifiedArrayOf<TextFieldButtonWithTCAProperty>

  mutating func addNewItem() {
    guard selectableItem.count < 5 else {
      return
    }
    selectableItem.append(.init(id: selectableItemID))
    selectableItemID += 1
  }

  mutating func delete(item: TextFieldButtonWithTCAProperty) {
    selectableItem = selectableItem.filter { $0 != item }
  }

  /// 전체보기를 제외한 (결혼식, 장례식, 돌잔치, 생일기념일, 자유)
  var availableSection: [VoteSectionHeaderItem] {
    return []
  }

  var voteTextContentPrompt = "투표 내용을 작성해주세요"
  var selectableItemPrompt = "선택지를 입력하세요"
  init() {
    _selectableItem = .init(.init(uniqueElements: [TextFieldButtonWithTCAProperty].default()))
    selectableItemID = selectableItem.count
  }
}

// MARK: - TextFieldButtonWithTCAProperty

struct TextFieldButtonWithTCAProperty: TextFieldButtonWithTCAPropertiable {
  var id: Int
  var title: String
  var isSaved: Bool
  var isEditing: Bool

  mutating func deleteTextFieldText() {}

  mutating func deleteTextField() {}

  mutating func savedTextField() {}

  mutating func editTextField(text: String) {
    title = text
  }

  init(id: Int, title: String, isSaved: Bool, isEditing: Bool) {
    self.id = id
    self.title = title
    self.isSaved = isSaved
    self.isEditing = isEditing
  }

  init(id: Int) {
    self.id = id
    title = ""
    isSaved = false
    isEditing = true
  }
}

extension [TextFieldButtonWithTCAProperty] {
  static func `default`() -> Self { return (0 ..< 2).map { .init(id: $0) } }
}
