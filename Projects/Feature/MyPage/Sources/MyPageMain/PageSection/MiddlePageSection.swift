//
//  MiddlePageSection.swift
//  MyPage
//
//  Created by MaraMincho on 9/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - MiddlePageSection

struct MiddlePageSection: Identifiable, Equatable, MyPageMainItemListCellItemable {
  var id: Int { type.id }
  var title: String { type.title }
  var subTitle: String?
  let type: MiddlePageSectionType

  init(type: MiddlePageSectionType, subTitle: String) {
    self.type = type
    self.subTitle = subTitle
  }

  mutating func updateSubtitle(_ val: String) {
    subTitle = val
  }
}

extension MiddlePageSection {
  static var `default`: [Self] {
    [
      .init(type: .appVersion, subTitle: ""),
    ]
  }
}

// MARK: - MiddlePageSectionType

enum MiddlePageSectionType: Int {
  case appVersion = 0
  var title: String {
    switch self {
    case .appVersion:
      "앱 버전"
    }
  }

  var id: Int { rawValue }
}
