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
  var genderItems: GenderButtonItems
  var selectedGenderItem: GenderButtonProperty?
  @Shared var selectedBirth: BottomSheetYearItem?

  func selectedGenderItemToBodyString() -> String? {
    guard let selectedGenderItem else {
      return nil
    }
    switch selectedGenderItem.id {
    case 0:
      return "남성"
    case 1:
      return "여성"
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
    genderItems = .makeInitialData()
    _selectedBirth = .init(nil)
    selectedGenderItem = nil
  }
}

typealias GenderButtonItems = [GenderButtonProperty]

extension GenderButtonItems {
  static func makeInitialData() -> Self {
    return [
      .init(id: 0, title: "남성"),
      .init(id: 1, title: "여성"),
    ]
  }
}

// MARK: - GenderButtonProperty

struct GenderButtonProperty: Equatable, Identifiable {
  var id: Int
  var title: String
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