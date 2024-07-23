//
//  OnboardingAdditionalProperty.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSBottomSelectSheet

// MARK: - OnboardingAdditionalProperty

struct OnboardingAdditionalProperty: Equatable {
  var genderItems: [GenderType]
  var selectedGenderItem: GenderType?
  @Shared var selectedBirth: BottomSheetYearItem?

  mutating func selectItem(_ item: GenderType) {
    selectedGenderItem = selectedGenderItem == item ? nil : item
  }

  func selectedGenderItemToBodyString() -> GenderType? {
    guard let selectedGenderItem else {
      return nil
    }
    switch selectedGenderItem.id {
    case 0:
      return .man
    case 1:
      return .woman
    default:
      return nil
    }
  }

  func selectedBirthItemToBodyString() -> Int? {
    guard
      let selectedBirth
    else {
      return nil
    }
    return Int(String(selectedBirth.id))
  }

  init() {
    genderItems = GenderType.allCases
    _selectedBirth = .init(nil)
    selectedGenderItem = nil
  }
}

// MARK: - GenderType

enum GenderType: Int, Encodable, Equatable, Identifiable, CaseIterable {
  case man = 0
  case woman

  var id: Int {
    rawValue
  }

  var title: String {
    switch self {
    case .man:
      "남성"
    case .woman:
      "여성"
    }
  }

  var jsonValue: String {
    switch self {
    case .man:
      "M"
    case .woman:
      "F"
    }
  }
}

// MARK: - BottomSheetYearItem

public struct BottomSheetYearItem: SSSelectBottomSheetPropertyItemable {
  public var description: String
  public var id: Int
}

extension BottomSheetYearItem {
  static func makeDefaultItems() -> [Self] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    let nowYear = dateFormatter.string(from: Date.now)
    guard let nowYearToInt = Int(nowYear) else {
      return []
    }
    let items: [Self] = (1950 ... nowYearToInt).map { val in
      return .init(description: val.description + "년", id: val)
    }
    return items.reversed()
  }
}
