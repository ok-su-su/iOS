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
  var textFieldPromptText: String { get }
  var prevSearchedNoContentTitleText: String { get }
  var prevSearchedNoContentDescriptionText: String { get }
  var textFieldText: String { get set }
  var iconType: SSSearchIconType { get set }
  var noSearchResultTitle: String { get set }
  var noSearchResultDescription: String { get set }

  associatedtype item: SSSearchItemable
  var prevSearchedItem: [item] { get set }
  var nowSearchedItem: [item] { get set }

  mutating func searchItem()
}

// MARK: - SSSearchIconType

public enum SSSearchIconType: Equatable, CaseIterable {
  case sent
  case inventory
  case vote
}

// MARK: - SSSearchItemable

public protocol SSSearchItemable: Equatable, Identifiable {
  var id: Int { get }
  var title: String { get }
  var firstContentDescription: String? { get }
  var secondContentDescription: String? { get }
}
