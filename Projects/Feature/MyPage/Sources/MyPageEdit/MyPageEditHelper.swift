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
  case female = 0
  case male

  var id: Int { return rawValue }

  /// Button의 타이틀에 사용됩니다.
  var description: String {
    switch self {
    case .male:
      "남성"
    case .female:
      "여성"
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

  static func getGenderByKey(_ val: String?) -> Self? {
    switch val {
    case "F":
      .female
    case "M":
      .male
    default:
      nil
    }
  }
}
