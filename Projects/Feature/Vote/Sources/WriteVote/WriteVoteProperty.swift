//
//  WriteVoteProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSNetwork
import SSRegexManager

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

  mutating func updateHeaderSectionItem(items: [VoteSectionHeaderItem], selectedID: Int? = nil) {
    _headerSectionItems = items.filter { $0.id != VoteSectionHeaderItem.initialState.id }
    if let selectedID {
      selectedSection = _headerSectionItems.first(where: { $0.id == selectedID })
    } else {
      selectedSection = _headerSectionItems.first
    }
  }

  func getVoteOptionModel() -> [VoteOptionWithoutIdModel] {
    return selectableItem
      .filter(\.isSaved)
      .enumerated()
      .map { .init(content: $0.element.title, seq: $0.offset + 1) }
  }

  var voteTextContentPrompt = "투표 내용을 작성해주세요"
  var selectableItemPrompt = "선택지를 입력하세요"

  var isCreatable: Bool {
    isTextFieldValid && isItemValid
  }

  var isTextFieldValid: Bool { RegexManager.isValidVoteContent(voteTextContent) }
  var isItemValid: Bool { selectableItem.filter { $0.isSaved == true }.count >= 2 }

  init() {
    _selectableItem = .init(.init(uniqueElements: [TextFieldButtonWithTCAProperty].default()))
    selectableItemID = selectableItem.count
  }
}
