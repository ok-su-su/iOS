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
  var voteTextContent: String = ""
  var selectableItemID: Int = 0
  @Shared var selectableItem: IdentifiedArrayOf<TextFieldButtonWithTCAProperty>

  mutating func addNewItem() {
    guard selectableItem.count < 5 else {
      return
    }
    selectableItem.append(.init(id: selectableItemID, regexString: TextFieldButtonWithTCAProperty.defaultRegex))
    selectableItemID += 1
  }

  mutating func delete(item: TextFieldButtonWithTCAProperty) {
    selectableItem = selectableItem.filter { $0 != item }
  }

  /// 전체보기를 제외한 (결혼식, 장례식, 돌잔치, 생일기념일, 자유)
  private var _headerSectionItems: [VoteSectionHeaderItem] = []
  var headerSectionItems: [VoteSectionHeaderItem] { _headerSectionItems }
  var selectedSection: VoteSectionHeaderItem? = nil

  mutating func updateHeaderSectionItem(items: [VoteSectionHeaderItem]) {
    _headerSectionItems = items.filter { $0.id != VoteSectionHeaderItem.initialState.id }
    selectedSection = _headerSectionItems.first
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
  static func == (lhs: TextFieldButtonWithTCAProperty, rhs: TextFieldButtonWithTCAProperty) -> Bool {
    if lhs.id == rhs.id,
       lhs.title == rhs.title,
       lhs.isSaved == rhs.isSaved,
       lhs.isEditing == rhs.isEditing {
      return true
    } else { return false }
  }

  var id: Int
  var title: String
  var isSaved: Bool
  var isEditing: Bool
  var regexString: Regex<Substring>?

  mutating func deleteTextFieldText() {}

  mutating func deleteTextField() {}

  mutating func savedTextField() {}

  mutating func editTextField(text: String) {
    title = text
  }

  init(id: Int, title: String, isSaved: Bool, isEditing: Bool, regexString _: Regex<Substring>?) {
    self.id = id
    self.title = title
    self.isSaved = isSaved
    self.isEditing = isEditing
  }

  init(id: Int, regexString: Regex<Substring>?) {
    self.id = id
    self.regexString = regexString
    title = ""
    isSaved = false
    isEditing = true
  }
}

extension [TextFieldButtonWithTCAProperty] {
  private static var defaultPropertyItemsCount: Int = 2
  static func `default`() -> Self {
    return (0 ..< defaultPropertyItemsCount).map { .init(id: $0, regexString: TextFieldButtonWithTCAProperty.defaultRegex) }
  }
}

extension TextFieldButtonWithTCAProperty {
  private static var defaultRegexPattern: String = "^.{1,10}$"
  static let defaultRegex: Regex<Substring> = try! .init(defaultRegexPattern)
}
