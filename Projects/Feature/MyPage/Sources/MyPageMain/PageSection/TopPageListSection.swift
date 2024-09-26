//
//  TopPageListSection.swift
//  MyPage
//
//  Created by MaraMincho on 9/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum TopPageListSection: Int, Identifiable, Equatable, CaseIterable, MyPageMainItemListCellItemable {
  case exportFromExcel
  case privacyPolicy

  var id: Int {
    return rawValue
  }

  var title: String {
    switch self {
    case .privacyPolicy:
      "개인정보 처리 방침"
    case .exportFromExcel:
      "액셀 파일로 내보내기"
    }
  }

  var subTitle: String? { nil }
}
