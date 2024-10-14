//
//  SSFilterWithSliderHelper.swift
//  SSFilter
//
//  Created by MaraMincho on 10/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import CommonExtension
import Foundation
import SSLayout

// MARK: - SliderFilterProperty

struct SSFilterWithSliderHelper: Equatable, Sendable {
  var sliderProperty = CustomSlider()
  private var sliderEndValue: Int64 = 0
  init() {}

  public mutating func sinkFilterPublisher() -> AnyPublisher<Void, Never> {
    return sliderProperty
      .objectWillChange
      .eraseToAnyPublisher()
  }

  public mutating func updateSliderMaximumValue(_ val: Int64?) {
    let isInitialState = sliderProperty.isInitialState
    guard let val else { return }
    sliderEndValue = val
    if isInitialState {
      updateSliderValueProperty()
    } else {
      let lowPercentage = Double(minimumTextValue) / Double(val)
      let highPercentage = Double(maximumTextValue) / Double(val)
      sliderProperty.updatePercentage(low: lowPercentage, high: highPercentage)
    }
  }

  public mutating func updateSliderPrevValue(minimumValue minVal: Int64?, maximumValue maxVal: Int64?) {
    if let minVal {
      minimumTextValue = minVal
    }
    if let maxVal {
      maximumTextValue = maxVal
    }
  }

  var sliderUpdatePublisher: AnyPublisher<Void, Never> {
    sliderProperty.objectWillChange.eraseToAnyPublisher()
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

  mutating func updateSliderValueProperty() {
    minimumTextValue = Int64(Double(sliderEndValue) * sliderProperty.currentLowHandlePercentage) / 10000 * 10000
    maximumTextValue = Int64(Double(sliderEndValue) * sliderProperty.currentHighHandlePercentage) / 10000 * 10000
  }

  mutating func reset() {
    sliderProperty.reset()
    updateSliderValueProperty()
  }
}
