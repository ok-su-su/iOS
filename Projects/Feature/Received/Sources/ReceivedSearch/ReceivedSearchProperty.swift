//
//  ReceivedSearchProperty.swift
//  Received
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSSearch

// MARK: - ReceivedSearchProperty

struct ReceivedSearchProperty: SSSearchPropertiable, Sendable {
  typealias item = ReceivedSearchItem
  var prevSearchedItem: [ReceivedSearchItem]
  var nowSearchedItem: [ReceivedSearchItem]
  var textFieldPromptText: String
  var prevSearchedNoContentTitleText: String
  var prevSearchedNoContentDescriptionText: String
  var textFieldText: String
  var iconType: SSSearchIconType
  var noSearchResultTitle: String
  var noSearchResultDescription: String

  init(
    prevSearchedItem: [ReceivedSearchItem],
    nowSearchedItem: [ReceivedSearchItem],
    textFieldPromptText: String,
    prevSearchedNoContentTitleText: String,
    prevSearchedNoContentDescriptionText: String,
    textFieldText: String,
    iconType: SSSearchIconType,
    noSearchResultTitle: String,
    noSearchResultDescription: String
  ) {
    self.prevSearchedItem = prevSearchedItem
    self.nowSearchedItem = nowSearchedItem
    self.textFieldPromptText = textFieldPromptText
    self.prevSearchedNoContentTitleText = prevSearchedNoContentTitleText
    self.prevSearchedNoContentDescriptionText = prevSearchedNoContentDescriptionText
    self.textFieldText = textFieldText
    self.iconType = iconType
    self.noSearchResultTitle = noSearchResultTitle
    self.noSearchResultDescription = noSearchResultDescription
  }
}

extension ReceivedSearchProperty {
  static var `default`: Self {
    .init(
      prevSearchedItem: [],
      nowSearchedItem: [],
      textFieldPromptText: "찾고 싶은 장부를 검색해보세요",
      prevSearchedNoContentTitleText: "어떤 장부를 찾아드릴까요?",
      prevSearchedNoContentDescriptionText: "장부 이름, 경조사 카테고리 등을\n검색해볼 수 있어요",
      textFieldText: "",
      iconType: .inventory,
      noSearchResultTitle: "원하는 검색 결과가 없나요?",
      noSearchResultDescription: "장부 이름, 경조사 카테고리 등을\n검색해볼 수 있어요"
    )
  }
}

// MARK: - ReceivedSearchItem

struct ReceivedSearchItem: SSSearchItemable, Codable, Hashable, Sendable {
  /// 장부의 아이디 입니다.
  var id: Int64
  /// 장부의 이름 입니다.
  var title: String
  /// 장부의 카테고리 입니다.
  var firstContentDescription: String?
  /// 장부의 날짜 입니다.
  var secondContentDescription: String?
}
