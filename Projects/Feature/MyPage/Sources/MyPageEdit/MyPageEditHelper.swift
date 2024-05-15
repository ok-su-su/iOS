//
//  MyPageEditHelper.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - MyPageEditHelper

struct MyPageEditHelper: Equatable {
  var originalValue: MyPageInformationProperty
  var editedValue: MyPageInformationProperty

  init() {
    // TODO: 초기값 지정할 수 있는 로직 생성
    originalValue = .init()
    editedValue = .init()
  }
}

// MARK: - Gender

enum Gender: Int, Identifiable, Equatable, CaseIterable {
  case male = 0
  case female

  var id: Int { return rawValue }
}

// MARK: - MyPageInformationPropertiable

protocol MyPageInformationPropertiable: Equatable {
  /// 내정보에 표시되는 이름입니다.
  var name: String? { get set }

  /// 내정보에 표시되는 생일 입니다.
  var birthDate: Date? { get set }

  /// 내정보에 표시되는 성별 입니다.
  var gender: Gender? { get set }
}

// MARK: - MyPageInformationProperty

struct MyPageInformationProperty: MyPageInformationPropertiable, Equatable {
  var name: String?
  var birthDate: Date?
  var gender: Gender?

  init(name: String? = nil, birthDate: Date? = nil, gender: Gender? = nil) {
    self.name = name
    self.birthDate = birthDate
    self.gender = gender
  }
}
