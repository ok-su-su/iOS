//
//  AgreeToTermsAndConditionsHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - AgreeToTermsAndConditionsHelper

struct AgreeToTermsAndConditionsHelper: Equatable {
  @Shared var termItems: IdentifiedArrayOf<TermItem>

  var activeNextScreenButton: Bool {
    return termItems.filter { $0.isSatisfy() == false }.isEmpty
  }

  func checkItemsID() -> [Int] {
    return termItems.filter(\.isCheck).map(\.id)
  }

  mutating func check(_ currentItem: TermItem) {
    termItems[id: currentItem.id]?.check()
  }

  mutating func checkAllItems() {
    if isAllCheckedItems {
      for ind in 0 ..< termItems.count {
        termItems[ind].isCheck = false
      }
    } else {
      for ind in 0 ..< termItems.count {
        termItems[ind].isCheck = true
      }
    }
  }

  var isAllCheckedItems: Bool {
    return termItems.filter { $0.isCheck == false }.isEmpty
  }

  init() {
    _termItems = .init(.init(uniqueElements: [TermItem].makeLocalItems()))
  }
}

// MARK: - TermItem

struct TermItem: Equatable, Identifiable {
  let id: Int
  let title: String
  let isEssential: Bool
  let isDetailContent: Bool
  var isCheck: Bool = false

  mutating func check() {
    isCheck.toggle()
  }

  func isSatisfy() -> Bool {
    return (isEssential && isCheck) || isCheck
  }

  init(id: Int, title: String, isEssential: Bool, isDetailContent: Bool) {
    self.id = id
    self.title = title
    self.isEssential = isEssential
    self.isDetailContent = isDetailContent
  }
}

extension [TermItem] {
  static func makeLocalItems() -> Self {
    [
      .init(id: 0, title: "만 14세 이상입니다.", isEssential: true, isDetailContent: false),
    ]
  }

  static func makeBy(dto: GetTermsInformationResponseDTO) -> Self {
    return dto.map { element in
      return .init(id: element.id, title: element.title, isEssential: element.isEssential, isDetailContent: element.isEssential)
    }
  }
}
