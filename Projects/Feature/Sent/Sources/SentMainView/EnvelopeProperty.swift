//
//  EnvelopeProperty.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Foundation

// MARK: - EnvelopeProperty

struct EnvelopeProperty: Equatable, Hashable, Identifiable {
  var id: UUID = .init()
  init() {}

  var envelopeContents: [EnvelopeContent] = [
    .fakeData(),
    .fakeData(),
    .fakeData(),
  ]
}

// MARK: - EnvelopeContent

struct EnvelopeContent: Equatable, Hashable, Identifiable {
  let id: UUID = .init()

  let date: Date
  let eventName: String
  let envelopeType: EnvelopeType
  let price: Int

  var priceText: String {
    return CustomNumberFormatter.formattedByThreeZero(price) ?? "0원"
  }

  var isHighlight: Bool {
    return id.hashValue % 2 == 0
  }

  /// EnvelopeContent를 정의합니다.
  /// - Parameters:
  ///   - date: 봉투를 보낸 날짜입니다.
  ///   - eventName: 이벤트 이름을 입력합니다.
  ///   - envelopeType: 받았는지 보냈는지 enum 을통해 입력받습니다.
  ///   - price: 가격을 입력합니다.
  init(date: Date, eventName: String, envelopeType: EnvelopeType, price: Int) {
    self.date = date
    self.eventName = eventName
    self.envelopeType = envelopeType
    self.price = price
  }

  static func fakeData() -> Self {
    return [
      EnvelopeContent(date: .now, eventName: "돌잔치", envelopeType: .receive, price: 50000),
      EnvelopeContent(date: .now, eventName: "돌잔치", envelopeType: .sent, price: 15000),
      EnvelopeContent(date: .now, eventName: "생일잔치", envelopeType: .sent, price: 15000),
      EnvelopeContent(date: .now, eventName: "생일잔치", envelopeType: .receive, price: 3000),
    ][Int.random(in: 0 ..< 3)]
  }

  enum EnvelopeType: Equatable {
    case sent
    case receive
  }
}
