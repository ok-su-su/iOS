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
  /// 봉투의 친구 아이디 입니다.
  var id: Int

  /// envelopeUserName입니다.
  private let envelopeTargetUserName: String
  /// 전체 금액입니다.
  private let totalPrice: Int
  /// 보낸 금액 입니다.
  let totalSentPrice: Int
  /// 받은 금액입니다.
  let totalReceivedPrice: Int
  /// envelopeUserName을 보여줍니다.
  var envelopeTargetUserNameText: String { envelopeTargetUserName }
  /// 전체 금액에 관한 Text입니디.
  var totalPriceText: String {
    "전체 \(CustomNumberFormatter.formattedByThreeZero(totalPrice) ?? "")원"
  }

  /// 봉투 세부 사항을 보여줍니다.
  var envelopeContents: [EnvelopeContent] = []

  init(
    id: Int,
    envelopeTargetUserName: String,
    totalPrice: Int,
    totalSentPrice: Int,
    totalReceivedPrice: Int
  ) {
    self.id = id
    self.envelopeTargetUserName = envelopeTargetUserName
    self.totalPrice = totalPrice
    self.totalSentPrice = totalSentPrice
    self.totalReceivedPrice = totalReceivedPrice
  }
}

// MARK: - EnvelopeContent

struct EnvelopeContent: Equatable, Hashable, Identifiable {
  let id: UUID = .init()

  let dateText: String
  let eventName: String
  let envelopeType: EnvelopeType
  let price: Int

  var priceText: String {
    return CustomNumberFormatter.formattedByThreeZero(price) ?? "0원"
  }

  var isSentView: Bool {
    return envelopeType == .sent
  }

  /// EnvelopeContent를 정의합니다.
  /// - Parameters:
  ///   - date: 봉투를 보낸 날짜입니다.
  ///   - eventName: 이벤트 이름을 입력합니다.
  ///   - envelopeType: 받았는지 보냈는지 enum 을통해 입력받습니다.
  ///   - price: 가격을 입력합니다.
  init(dateText: String, eventName: String, envelopeType: EnvelopeType, price: Int) {
    self.dateText = dateText
    self.eventName = eventName
    self.envelopeType = envelopeType
    self.price = price
  }

  enum EnvelopeType: Equatable {
    case sent
    case receive
  }
}
