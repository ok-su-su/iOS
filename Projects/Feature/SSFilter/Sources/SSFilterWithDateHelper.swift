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
    let endDateString = CustomDateFormatter.getString(from: endDate, dateFormat: "yyyy.MM.dd")
    let startDateString = CustomDateFormatter.getString(from: startDate, dateFormat: "yyyy.MM.dd")
    switch (isInitialStateOfStartDate, isInitialStateOfEndDate) {
    case (true, true):
      return nil
    case (true, false):
      return "~" + endDateString
    case (false, true):
      return startDateString
    case (false, false):
      return startDateString + "~" + endDateString
    }
  }

  mutating func updateDateOf(startDate: Date?, endDate: Date?) {
    resetDate()
    if let startDate {
      self.startDate = startDate
      isInitialStateOfStartDate = false
    }

    if let endDate {
      self.endDate = endDate
      isInitialStateOfEndDate = false
    }
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
