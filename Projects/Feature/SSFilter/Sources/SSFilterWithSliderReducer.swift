//
//  SSFilterWithSliderProperty.swift
//  SSFilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SSLayout
import FeatureAction
import CommonExtension

@Reducer
struct SSFilterWithSliderReducer: Sendable {

  @ObservableState
  struct State: Equatable, Sendable {
    @Shared var sliderProperty: SliderFilterProperty
  }
}

struct SliderFilterProperty: Equatable, Sendable {
  var sliderProperty = CustomSlider()
  var lowestAmount: Int64? = nil
  var highestAmount: Int64? = nil

  mutating func deselectAmount() {
    lowestAmount = nil
    highestAmount = nil
  }
  var minimumTextValue: Int64 = 0
  var maximumTextValue: Int64 = 0
  var minimumTextValueString: String { CustomNumberFormatter.formattedByThreeZero(minimumTextValue) ?? "0" }
  var maximumTextValueString: String { CustomNumberFormatter.formattedByThreeZero(maximumTextValue) ?? "0" }
  var sliderRangeText: String {
    "\(minimumTextValueString)원 ~ \(maximumTextValueString)원"
  }
  var isInitialState: Bool {
    return minimumTextValue == 0 && maximumTextValue == sliderEndValue
  }
}
