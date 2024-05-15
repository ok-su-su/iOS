//
//  MyPageEditHelper.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct MyPageEditHelper {
  var originalValue: MyPageInformationProperty
  var editedValue: MyPageInformationProperty
}

enum Gender: Int, Identifiable  {
  case male = 0
  case female
  
  var id: Int { return rawValue }
}

protocol MyPageInformationPropertiable {
  
  /// 내정보에 표시되는 이름입니다.
  var name: String? { get set}
  
  /// 내정보에 표시되는 생일 입니다.
  var birthDate: Date? {get set}
  
  /// 내정보에 표시되는 성별 입니다.
  var gender: Gender? { get set }
}

extension MyPageInformationPropertiable {
  
}

struct MyPageInformationProperty: MyPageInformationPropertiable {
  var name: String?
  var birthDate: Date?
  var gender: Gender?
  
  init(name: String? = nil, birthDate: Date? = nil, gender: Gender? = nil) {
    self.name = name
    self.birthDate = birthDate
    self.gender = gender
  }
}
