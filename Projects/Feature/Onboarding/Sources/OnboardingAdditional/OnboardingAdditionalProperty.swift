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

extension [BottomSheetYearItem] {
  static var `default`: Self {
    BottomSheetYearItem.default
  }
}

extension BottomSheetYearItem {
  static var `default`: [Self] {
    let defaultItems: [Self] = (1930 ... Int(getYear(from: .now))!)
      .map { .init(description: $0.description + "년", id: $0) }
      .reversed()
    return [.deselectItem] + defaultItems
  }

  static var deselectItem: Self {
    let notSelectedID = Int.min
    return .init(description: "미선택", id: notSelectedID)
  }

  private static func getYear(from date: Date) -> String {
    dateFormatter.string(from: date)
  }

  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter
  }()
}
