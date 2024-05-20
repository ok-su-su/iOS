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
  var selectedSection: VoteSectionHeaderItem = .wedding
  var voteTextContent: String = ""
  @Shared var selectableItem: IdentifiedArrayOf<TextFieldButtonWithTCAProperty>

  mutating func addNewItem() {
    let nextID = selectableItem.count
    selectableItem.append(.init(id: nextID))
  }

  mutating func delete(item: TextFieldButtonWithTCAProperty) {
    selectableItem = selectableItem.filter { $0 != item }
  }

  /// 전체보기를 제외한 (결혼식, 장례식, 돌잔치, 생일기념일, 자유)
  var availableSection: [VoteSectionHeaderItem] {
    return VoteSectionHeaderItem.allCases.filter { $0 == .all }
  }

  var voteTextContentPrompt = "투표 내용을 작성해주세요"
  var selectableItemPrompt = "선택지를 입력하세요"
  init() {
    _selectableItem = .init(.init(uniqueElements: [TextFieldButtonWithTCAProperty].default()))
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
    isEditing = false
  }
}

extension [TextFieldButtonWithTCAProperty] {
  static func `default`() -> Self { return (0 ..< 2).map { .init(id: $0) } }
}
