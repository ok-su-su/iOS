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
  var id: Int64

  /// envelopeUserName입니다.
  private let envelopeTargetUserName: String
  /// 전체 금액입니다.
  private let totalPrice: Int64
  /// 보낸 금액 입니다.
  let totalSentPrice: Int64
  /// 받은 금액입니다.
  let totalReceivedPrice: Int64
  /// envelopeUserName을 보여줍니다.
  var envelopeTargetUserNameText: String { envelopeTargetUserName }
  /// 전체 금액에 관한 Text입니다.
  var totalPriceText: String {
    "전체 \(CustomNumberFormatter.formattedByThreeZero(totalPrice) ?? "")원"
  }

  var receivedSubSentValue: Int64 {
    return totalReceivedPrice - totalSentPrice
  }

  /// 봉투 세부 사항을 보여줍니다.
  var envelopeContents: [EnvelopeContent] = []

  init(
    id: Int64,
    envelopeTargetUserName: String,
    totalPrice: Int64,
    totalSentPrice: Int64,
    totalReceivedPrice: Int64
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
  /// 봉투의 아이디 입니다.
  let id: Int64
  /// 봉투에 표시될 날짜 입ㄴ디ㅏ.
  let dateText: String
  /// 봉투의 Event Name 입니다.
  let eventName: String
  /// 봉투의 타입 입니다.
  let envelopeType: EnvelopeType
  /// 봉투의 가격 입니다.
  let price: Int64

  var priceText: String {
    return CustomNumberFormatter.formattedByThreeZero(price) ?? "0원"
  }

  var isSentView: Bool {
    return envelopeType == .sent
  }

  /// EnvelopeContent를 정의합니다.
  /// - Parameters:
  ///   - id: 봉투의 ID 입니다.
  ///   - date: 봉투를 보낸 날짜입니다.
  ///   - eventName: 이벤트 이름을 입력합니다.
  ///   - envelopeType: 받았는지 보냈는지 enum 을통해 입력받습니다.
  ///   - price: 가격을 입력합니다.
  init(id: Int64, dateText: String, eventName: String, envelopeType: EnvelopeType, price: Int64) {
    self.id = id
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
