//
//  FilterHelperProperty.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct FilterHelperProperty: Equatable {
  var selectedLedger: [LedgerBoxProperty] = []

  var filteredDateTextString: String? {
    guard let startDate else {
      return nil
    }
    let startDateString = CustomDateFormatter.getString(from: startDate, dateFormat: "yyyy.MM.dd")
    guard let endDate else {
      return startDateString
    }
    let endDateString = CustomDateFormatter.getString(from: endDate, dateFormat: "yyyy.MM.dd")
    return startDateString + "~" + endDateString
  }
  var startDate: Date?
  var endDate: Date?

  mutating func resetDate() {
    startDate = nil
    endDate = nil
  }

  mutating func deleteSelectedItem(id: Int64) {
    guard let index = selectedLedger.firstIndex(where: {$0.id == id}) else {
      return
    }
    selectedLedger.remove(at: index)
  }
}
