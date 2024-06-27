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

struct VoteSearchItem: SSSearchItemable {
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

  mutating func searchItem(by text: String) {
    // TODO: SomeThing Search Reuslt
    fakeSearch(by: text)
  }

  var fakeVotes: [VoteSearchItem] = [
    .init(id: 0, title: "김사랑"),
    .init(id: 1, title: "김헤이즈"),
    .init(id: 2, title: "김매그너스"),
    .init(id: 3, title: "김카밀로"),
    .init(id: 4, title: "김니키"),
    .init(id: 5, title: "김버니스"),
    .init(id: 6, title: "김사랑해"),
  ]

  mutating func fakeSearchHistory() {
    prevSearchedItem = fakeVotes
  }

  mutating func fakeSearch(by text: String) {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(text)[\\w\\p{L}]*") else {
      return nowSearchedItem = []
    }
    nowSearchedItem = fakeVotes.filter { $0.title.contains(regex) }
  }

  mutating func deletePrevItem(prevItemID id: Int64) {
    // TODO: 삭제 기능 구현.
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
    noSearchResultDescription = "SomeTing"
    iconType = .vote

    // TODO: - delete
    if Bool.random() { fakeSearchHistory() }
  }
}
