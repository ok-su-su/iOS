//
//  CustomDateFormatter.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final class CustomDateFormatter {
  private static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }()

  // yyyy-MM-dd'T'HH:mm:ss.SSS... String을 Date로 변환시켜 줍니다.
  static func getDate(from val: String) -> Date? {
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let targetString = String(val.prefix(19))
    return formatter.date(from: targetString)
  }

  /// yyyy.MM.dd 의 String으로 반환해줍니다.
  static func getYearAndMonthDateString(from val: String?) -> String? {
    guard let val,
          let date = getDate(from: val)
    else {
      return nil
    }
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: date)
  }

  /// Date을 yyyy-MM-dd'T'HH:mm:ss 포멧의 Date로 변경시켜 줍니다.
  static func getFullDateString(from val: Date) -> String {
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.string(from: val)
  }

  static func getKoreanDateString(from date: Date) -> String {
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
  }

  /// Date을 dateFormmate으로 변경시켜줍니다.
  static func getString(from val: Date, dateFormat: String? = nil) -> String {
    if let dateFormat {
      formatter.dateFormat = dateFormat
    }
    return formatter.string(from: val)
  }

  static func getYear(from val: Date) -> String {
    formatter.dateFormat = "yyyy"
    return formatter.string(from: val)
  }

  static func getMonth(from val: Date) -> String {
    formatter.dateFormat = "MM"
    return formatter.string(from: val)
  }

  static func getDay(from val: Date) -> String {
    formatter.dateFormat = "dd"
    return formatter.string(from: val)
  }

  private init() {}
}
