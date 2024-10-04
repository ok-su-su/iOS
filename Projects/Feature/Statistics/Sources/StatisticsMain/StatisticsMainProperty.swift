//
//  StatisticsMainProperty.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - StatisticsMainProperty

struct StatisticsMainProperty: Equatable, Sendable {
  var selectedStepperType: StepperType = .my
}

// MARK: - StepperType

enum StepperType: Int, Equatable, CaseIterable, Identifiable, Sendable {
  case my = 0
  case other
  var id: Int {
    return rawValue
  }

  var title: String {
    switch self {
    case .my:
      return "나의 수수"
    case .other:
      return "수수 평균"
    }
  }
}
