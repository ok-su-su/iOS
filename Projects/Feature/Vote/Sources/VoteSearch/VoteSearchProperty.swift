//
//  VoteSearchProperty.swift
//  Vote
//
//  Created by MaraMincho on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSSearch

// MARK: - VoteSearchItem

struct VoteSearchItem: SSSearchItemable, Codable, Equatable, Hashable {
  var id: Int64
  var title: String
  var firstContentDescription: String?
  var secondContentDescription: String?
}

// MARK: - VoteSearchProperty

struct VoteSearchProperty: SSSearchPropertiable {
  typealias item = VoteSearchItem

  var textFieldPromptText: String
  var prevSearchedNoContentTitleText: String
  var prevSearchedNoContentDescriptionText: String
  var noSearchResultTitle: String
  var noSearchResultDescription: String
  var iconType: SSSearchIconType

  // TODO: 삭제 기능 구현.
  mutating func deletePrevItem(prevItemID id: Int64) {
    prevSearchedItem = prevSearchedItem.filter { $0.id != id }
  }

  func titleByPrevItem(id: Int64) -> String {
    return prevSearchedItem.first(where: { $0.id == id })?.title ?? ""
  }

  var textFieldText: String = ""
  var prevSearchedItem: [VoteSearchItem] = []
  var nowSearchedItem: [VoteSearchItem] = []

  init(
    textFieldPromptText: String,
    prevSearchedNoContentTitleText: String,
    prevSearchedNoContentDescriptionText: String,
    noSearchResultTitle: String,
    noSearchResultDescription: String,
    iconType: SSSearchIconType
  ) {
    self.textFieldPromptText = textFieldPromptText
    self.prevSearchedNoContentTitleText = prevSearchedNoContentTitleText
    self.prevSearchedNoContentDescriptionText = prevSearchedNoContentDescriptionText
    self.noSearchResultTitle = noSearchResultTitle
    self.noSearchResultDescription = noSearchResultDescription
    self.iconType = iconType
  }

  init() {
    textFieldPromptText = "찾고 싶은 투표를 검색해보세요"
    prevSearchedNoContentTitleText = "어떤 투표를 찾아드릴까요?"
    prevSearchedNoContentDescriptionText = "궁금하신 것들의 키워드를\n검색해볼 수 있어요"
    noSearchResultTitle = "원하는 검색 결과가 없나요?"
    noSearchResultDescription = "궁금한 것들의 키워드를\n검색해볼 수 있어요"
    iconType = .vote
  }
}
