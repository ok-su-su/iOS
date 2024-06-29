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

  var selectedGender: Gender? {
    // 수정된 Gedner가 있을 때
    if editedValue.gender == nil {
      return originalValue.gender
    }
    // 없을 때
    return editedValue.gender
  }

  var namePromptText: String {
    return originalValue.name == "" ? "김수수" : originalValue.name
  }

  var birthDayNotEditedText: String {
    return textTo(date: originalValue.birthDate)
  }

  var birthDayDate: Date? {
    guard let date = editedValue.birthDate else {
      return originalValue.birthDate
    }
    return date
  }

  var birthDayText: String {
    if editedValue.birthDate == nil {
      return textTo(date: originalValue.birthDate)
    }
    return textTo(date: editedValue.birthDate)
  }

  /// Date를 화면에 표시가능한 Text로 변환해 줍니다.
  private func textTo(date: Date?) -> String {
    guard let date else {
      return "2024년"
    }
    return SelectYearItemDateFormatter.yearStringFrom(date: date)
  }

  mutating func setEditDate(by value: String) {
    if let date = SelectYearItemDateFormatter.dateFrom(string: value) {
      editedValue.birthDate = date
    }
  }

  func isEditedBirthDay() -> Bool {
    return !(editedValue.birthDate == nil)
  }

  mutating func editName(text: String) {
    editedValue.name = text
  }
}

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
      "W"
    }
  }

  static func initByString(_ val: String) -> Self? {
    allCases.filter { $0.genderIdentifierString == val }.first
  }
}

// MARK: - MyPageInformationPropertiable

protocol MyPageInformationPropertiable: Equatable {
  /// 내정보에 표시되는 이름입니다.
  var name: String { get set }

  /// 내정보에 표시되는 생일 입니다.
  var birthDate: Date? { get set }

  /// 내정보에 표시되는 성별 입니다.
  var gender: Gender? { get set }
}

// MARK: - MyPageInformationProperty

struct MyPageInformationProperty: MyPageInformationPropertiable, Equatable {
  var name: String
  var birthDate: Date?
  var gender: Gender?

  init(name: String = "", birthDate: Date? = nil, gender: Gender? = nil) {
    self.name = name
    self.birthDate = birthDate
    self.gender = gender
  }
}
