//
//  TopPageListSection.swift
//  MyPage
//
//  Created by MaraMincho on 9/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum TopPageListSection: Int, Identifiable, Equatable, CaseIterable, MyPageMainItemListCellItemable {
  case privacyPolicy

  var id: Int {
    return rawValue
  }

  var title: String {
    switch self {
    case .privacyPolicy:
      "개인정보 처리 방침"
    }
  }

  var subTitle: String? { nil }
}
