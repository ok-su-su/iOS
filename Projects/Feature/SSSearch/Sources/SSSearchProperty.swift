//
//  SSSearchProperty.swift
//  SSSearch
//
//  Created by MaraMincho on 5/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SSSearchPropertiable

public protocol SSSearchPropertiable: Equatable {
  /// TextField에 표시될 Prompt Text입니다.
  var textFieldPromptText: String { get }
  /// 과거에 검색한 이력이 없을 경우 보여줄 Title 입니다.
  var prevSearchedNoContentTitleText: String { get }
  /// 과거에 검색한 이력이 없을 경우 보여줄 Title의 설명 입니다.
  var prevSearchedNoContentDescriptionText: String { get }
  /// 검색시 활용될 textFieldText입니다.
  var textFieldText: String { get set }
  /// 검색시 보여줄 아이콘 타입입니다.
  var iconType: SSSearchIconType { get set }
  /// 검색 결과가 없을 경우 보여줄 Title입니다.
  var noSearchResultTitle: String { get set }
  /// 검색 결과가 없을 경우 보여줄 Title의 설명입니다.
  var noSearchResultDescription: String { get set }

  /// 검색 혹은, 과거 검색 이력에 사용되는 타입입니다.
  associatedtype item: SSSearchItemable
  /// 과거 검색 기록들을 보관합니다.
  var prevSearchedItem: [item] { get set }
  /// 검색 결과를 보관합니다.
  var nowSearchedItem: [item] { get set }
}

// MARK: - SSSearchIconType

public enum SSSearchIconType: Equatable, CaseIterable {
  case sent
  case inventory
  case vote
}

// MARK: - SSSearchItemable

public protocol SSSearchItemable: Equatable, Identifiable {
  /// 검색시 표시될 아이디 입니다.
  var id: Int64 { get }
  /// 검색시 표시될 이름 입니다.
  var title: String { get }
  /// 검색시 표시될 설명의 첫번째 Text입니다. 보통 경조사 이름을 기재합니다.
  var firstContentDescription: String? { get }
  /// 검색시 표시될 설명의 첫번째 Text입니다. 보통 날짜를 기재합니다.
  var secondContentDescription: String? { get }
}
