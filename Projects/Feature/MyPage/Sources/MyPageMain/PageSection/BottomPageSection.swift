//
//  BottomPageSection.swift
//  MyPage
//
//  Created by MaraMincho on 9/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum BottomPageSection: Int, Identifiable, Equatable, CaseIterable, MyPageMainItemListCellItemable {
  case logout
  case resign

  var id: Int {
    return rawValue
  }

  var title: String {
    switch self {
    case .logout:
      "로그아웃"
    case .resign:
      "탈퇴하기"
    }
  }

  var subTitle: String? { nil }
}
