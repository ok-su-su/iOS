//
//  String+Date.swift
//  Vote
//
//  Created by MaraMincho on 8/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

extension Date {
  private static var dateFormatter: DateFormatter = .init()

  /// 특정 날짜로부터 얼마나 시간이 지났는지 체크하는 함수
  func secondsSinceNow() -> Int {
    let now = Date()
    let elapsedTime = now.timeIntervalSince(self) // 현재 시간으로부터 self로 지정된 날짜까지의 시간 간격을 구함
    return Int(elapsedTime)
  }

  func string(dateFormat: String) -> String {
    Date.dateFormatter.dateFormat = dateFormat
    return Date.dateFormatter.string(from: self)
  }
}

extension String {
  /// iSO8601String으로 부터 현재 시간과 얼마나 벌어졌는지 String을 통해 보여줍니다.
  /// - Returns: 필요한 Label을 return합니다.
  ///
  ///  기본 [YYYY.MM.DD]로 표시
  ///  당일에 작성된 투표의 경우 [n 시간전]
  ///  1시간 이내에 작성된 투표의 경우 [n 분전]
  func subtractFromNowAndMakeLabel() -> String {
    guard let targetDate = fromISO8601ToDate() else {
      // TODO: GA탑재
      return ""
    }
    let interval = targetDate.secondsSinceNow()
    if interval / 3600 == 0 {
      let targetMinute = interval / 60
      return targetMinute.description + Constants.minuteSubfixString
    } else if targetDate == .now {
      let targetHours = interval / 3600
      return targetHours.description + Constants.hourSubfixString
    } else {
      return targetDate.string(dateFormat: Constants.dateFormat)
    }
  }

  private enum Constants {
    static let dateFormat: String = "yyyy.MM.dd"
    static let minuteSubfixString: String = "분 전"
    static let hourSubfixString: String = "시간 전"
  }
}
