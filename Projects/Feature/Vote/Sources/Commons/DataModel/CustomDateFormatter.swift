//
//  CustomDateFormatter.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

enum CustomDateFormatter {
  static let dateFormatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.dateFormat = "yyyy.mm.dd"
    return formatter
  }()

  static func stringFrom(date: Date) -> String {
    return dateFormatter.string(from: date)
  }
}
