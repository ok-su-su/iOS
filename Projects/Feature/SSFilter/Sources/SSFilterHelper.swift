//
//  SSFilterHElper.swift
//  SSFilter
//
//  Created by MaraMincho on 10/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import CommonExtension
import SSLayout
import Combine

public struct SSFilterItemHelper<Item: SSFilterItemable>: Equatable, Sendable {
  var selectableItems: [Item]
  var selectedItems: [Item]

  mutating func select(_ id: Int) {
    // 이미 선택되었다면 제거
    if let index = selectedItems.firstIndex(where: { $0.id == id }) {
      selectedItems.remove(at: index)
      return
    }

    // 선택이 안되었다면 선택
    if let ledger = selectableItems.first(where: { $0.id == id }) {
      selectedItems.append(ledger)
    }
  }

  mutating func reset() {
    selectedItems = []
  }
}

public struct SSFilterWithSliderProperty: Equatable, Sendable {
  var sliderProperty: CustomSlider = .init()

  var sliderStartValue: Int64 = 0
  var sliderEndValue: Int64 = 0

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

  var sliderPropertyWillChange: AnyPublisher<Void, Never> {
    sliderProperty.objectWillChange.eraseToAnyPublisher()
  }

  var sliderPropertyTapped: AnyPublisher<Void, Never> {
    sliderProperty.tapPublisher.eraseToAnyPublisher()
  }

  func reset() {
    sliderProperty.reset()
  }
}



struct SSFilterWithDateHelper: Equatable, Sendable {
  init() {}
  var isInitialStateOfStartDate: Bool = true
  var startDate: Date = .now
  var isInitialStateOfEndDate: Bool = true
  var endDate: Date = .now


  var selectedFilterDateTextString: String? {
    if isInitialStateOfStartDate {
      return nil
    }
    let startDateString = CustomDateFormatter.getString(from: startDate, dateFormat: "yyyy.MM.dd")
    if isInitialStateOfEndDate {
      return startDateString
    }
    let endDateString = CustomDateFormatter.getString(from: endDate, dateFormat: "yyyy.MM.dd")
    return startDateString + "~" + endDateString
  }

  mutating func setStartDate(_ date: Date) {
    startDate = date
  }

  mutating func setEndDate(_ date: Date) {
    endDate = date
  }

  mutating func resetDate() {
    isInitialStateOfStartDate = true
    startDate = .now

    isInitialStateOfEndDate = true
    endDate = .now
  }

  mutating func setInitialState() {
    resetDate()
  }

}

public protocol SSFilterItemable: Equatable, Sendable, Identifiable where ID == Int{
  var id: Int { get }
  var title: String { get set }
}
