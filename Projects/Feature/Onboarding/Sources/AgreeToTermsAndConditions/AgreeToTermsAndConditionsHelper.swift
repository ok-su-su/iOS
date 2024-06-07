//
//  AgreeToTermsAndConditionsHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

// MARK: - AgreeToTermsAndConditionsHelper

struct AgreeToTermsAndConditionsHelper: Equatable {
  var termItems: [TermItem]

  init(termItems: [TermItem]) {
    self.termItems = termItems
  }

  var activeNextScreenButton: Bool {
    return termItems.filter { $0.isSatisfy() == false }.isEmpty
  }

  mutating func check(_ currentItem: TermItem) {
    termItems = termItems.map { item in
      var item = item
      if currentItem == item {
        item.check()
      }
      return item
    }
  }

  mutating func checkAllItems() {
    if isAllCheckedItems {
      termItems = termItems.map { item in
        var item = item
        item.isCheck = false
        return item
      }
    } else {
      termItems = termItems.map { item in
        var item = item
        item.isCheck = true
        return item
      }
    }
  }

  var isAllCheckedItems: Bool {
    let checkCount = termItems.filter { $0.isCheck == false }.count
    os_log("카운트는 = \(checkCount), isEmpty = \(termItems.isEmpty)")
    return termItems.filter { $0.isCheck == false }.isEmpty
  }

  init() {
    termItems = .makeFakeData()
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
  static func makeFakeData() -> Self {
    [
      .init(id: 0, title: "만 14세 이상입니다.", isEssential: true, isDetailContent: false),
      .init(id: 1, title: "서비스 이용 약관", isEssential: true, isDetailContent: true),
      .init(id: 2, title: "개인 정보 수집 및 이용안내", isEssential: true, isDetailContent: true),
    ]
  }
}

// {
//  "id": 1,
//  "title": "서비스 이용 약관",
//  "isEssential": true
// },
// {
//  "id": 2,
//  "title": "개인 정보 수집 및 이용안내",
//  "isEssential": true
// }
