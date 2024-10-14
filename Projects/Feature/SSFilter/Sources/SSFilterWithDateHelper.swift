//
//  SSFilterWithDateHelper.swift
//  SSFilter
//
//  Created by MaraMincho on 10/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SSFilterWithDateHelper

struct SSFilterWithDateHelper: Equatable, Sendable {
  init() {}
  var isInitialStateOfStartDate: Bool = true
  var startDate: Date = .now
  var isInitialStateOfEndDate: Bool = true
  var endDate: Date = .now

  var defaultDateText: String {
    CustomDateFormatter.getYearAndMonthDateString(from: Date.now) ?? ""
  }

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

  var startDateText: String? {
    if !isInitialStateOfStartDate {
      return CustomDateFormatter.getYearAndMonthDateString(from: startDate)
    }
    return nil
  }

  var endDateText: String? {
    if !isInitialStateOfEndDate {
      return CustomDateFormatter.getYearAndMonthDateString(from: endDate)
    }
    return nil
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
