//
//  MyPageEditHelper.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - Gender

enum Gender: Int, Identifiable, Equatable, CaseIterable, CustomStringConvertible {
  case male = 0
  case female

  var id: Int { return rawValue }

  /// Button의 타이틀에 사용됩니다.
  var description: String {
    switch self {
    case .male:
      "남자"
    case .female:
      "여자"
    }
  }

  var genderIdentifierString: String {
    switch self {
    case .male:
      "M"
    case .female:
      "F"
    }
  }

  static func initByString(_ val: String) -> Self? {
    allCases.filter { $0.genderIdentifierString == val }.first
  }
}
