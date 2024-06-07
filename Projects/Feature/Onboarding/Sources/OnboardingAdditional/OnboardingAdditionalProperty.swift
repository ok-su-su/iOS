//
//  OnboardingAdditionalProperty.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - OnboardingAdditionalProperty

struct OnboardingAdditionalProperty: Equatable {
  var genderItems: GenderButtonItems
  var selectedGenderItem: GenderButtonProperty?
  var selectedBirth: String?

  init() {
    genderItems = .makeInitialData()
    selectedBirth = nil
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
