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
}

public struct SSFilterSliderProperty: Equatable, Sendable {
  var sliderProperty: CustomSlider = .init()
  var minimumTextValue: Int64 = 0
  var maximumTextValue: Int64 = 0
  var minimumTextValueString: String { CustomNumberFormatter.formattedByThreeZero(minimumTextValue) ?? "0" }
  var maximumTextValueString: String { CustomNumberFormatter.formattedByThreeZero(maximumTextValue) ?? "0" }
}



public struct SSFilterWithDateHelper: Equatable, Sendable {
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
