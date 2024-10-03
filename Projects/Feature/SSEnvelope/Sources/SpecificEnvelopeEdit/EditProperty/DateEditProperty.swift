//
//  DateEditProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - DateEditProperty

struct DateEditProperty: Equatable, EnvelopeEditPropertiable {
  let originalDate: Date
  var date: Date
  var isInitialState = false
  var dateText: String {
    return CustomDateFormatter.getKoreanDateString(from: date)
  }

  init(date: Date) {
    self.date = date
    originalDate = date
  }

  var isValid: Bool {
    true
  }

  var isChanged: Bool {
    originalDate != date
  }
}
