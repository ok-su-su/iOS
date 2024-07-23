//
//  OnboardingLoginHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct OnboardingLoginHelper: Equatable {
  var displaySectorShapeDegree: Double = 0
  private var currentSectorShapeDegree: Double

  var displayPercentageText: String = ""
  private var currentPercentageText: String

  var displayPriceText: String = ""
  private var currentPriceText: String

  init() {
    currentSectorShapeDegree = -360 + 45
    currentPercentageText = "87%"
    currentPriceText = "10만원"
  }

  /// 애네메이션에 활용
  mutating func setSectorShapeProperty() {
    displaySectorShapeDegree = currentSectorShapeDegree
  }

  /// 애네메이션에 활용
  mutating func setTextProperty() {
    displayPriceText = currentPriceText
    displayPercentageText = currentPercentageText
  }
}
