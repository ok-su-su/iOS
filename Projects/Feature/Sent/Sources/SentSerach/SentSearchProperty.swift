//
//  SentSearchProperty.swift
//  Sent
//
//  Created by MaraMincho on 11/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSSearch

// MARK: - SentSearchProperty

struct SentSearchProperty: SSSearchPropertiable, Sendable {
  typealias item = SentSearchItem
  var prevSearchedItem: [item]
  var nowSearchedItem: [item]
  var textFieldPromptText: String
  var prevSearchedNoContentTitleText: String
  var prevSearchedNoContentDescriptionText: String
  var textFieldText: String
  var iconType: SSSearchIconType
  var noSearchResultTitle: String
  var noSearchResultDescription: String
}

extension SentSearchProperty {
  static func `default`() -> Self {
    .init(
      prevSearchedItem: [],
      nowSearchedItem: [],
      textFieldPromptText: "찾고 싶은 봉투를 검색해보세요",
      prevSearchedNoContentTitleText: "어떤 봉투를 찾아드릴까요?",
      prevSearchedNoContentDescriptionText: "궁금하신 것들의 키워드를\n검색해볼 수 있어요",
      textFieldText: "",
      iconType: .sent,
      noSearchResultTitle: "원하는 검색 결과가 없나요?",
      noSearchResultDescription: "사람 이름, 보낸 금액 등을\n검색해볼 수 있어요"
    )
  }
}

// MARK: - SentSearchItem

struct SentSearchItem: SSSearchItemable, Hashable, Codable, Sendable {
  /// 친구의 아이디 입니다.
  var id: Int64
  /// 친구의 이름 입니다.
  var title: String
  /// 경조사 이름 입니다.
  var firstContentDescription: String?
  /// 날짜 이름 입니다.
  var secondContentDescription: String?
}
