//
//  Date+.swift
//  Vote
//
//  Created by MaraMincho on 8/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

extension Date {
    private static var ISODateFormatter: ISO8601DateFormatter = .init()
    private static var dateFormatter: DateFormatter = .init()
    private static let dateFormat: String = "HHmmss"

    // 특정 날짜로부터 얼마나 시간이 지났는지 체크하는 함수
  func secondsSinceNow() -> TimeInterval {
    let now = Date()
    let elapsedTime = now.timeIntervalSince(self) // 현재 시간으로부터 self로 지정된 날짜까지의 시간 간격을 구함
    return elapsedTime
  }
  func string(dateFormat: String) -> String {
    Date.dateFormatter.dateFormat = dateFormat
    return Date.dateFormatter.string(from: self)
  }
}


extension String {
  func subtractFromNowAndMakeLabel() -> String {
    guard  let targetDate = self.fromISO8601ToDate() else {
      return ""
    }
    let interval = targetDate.secondsSinceNow()
    if interval / 3600 == 0  {
      let targetMinute = Int(interval / 60)
      return targetMinute.description + "분 전"
    }else if targetDate == .now {
      let targetHours = Int(interval / 3600)
      return targetHours.description + "시간 전"
    }else {
      return targetDate.string(dateFormat: Constants.dateFormat)
    }
  }
  private enum Constants {
    static let dateFormat: String = "yyyy.MM.dd"
  }

}

