//
//  EnvelopeDetailProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct EnvelopeDetailProperty: Equatable, Identifiable {
  /// 봉투의 아이디 입니다.
  public let id: Int64
  /// Send OR RECEIVED
  var type: String
  /// 장부 아이디 입니다.
  var ledgerID: Int64?
  /// 현재 봉투의 가격을 나타냅니다.
  let price: Int64
  /// 현재 봉투의 경조사 이름을 나타냅니다.
  let eventName: String
  /// 현재 봉투 카테고리 ID를 나타냅니다.
  let eventID: Int
  /// 봉투를 받은 사람의 ID입니다.
  let friendID: Int64
  /// 봉투를 받은 사람의 이름을 나타냅니다.
  let name: String
  ///  현재 봉투를 주고받은 사람과의 관계를 나타냅니다.
  let relation: String
  /// 봉투 relationID를 나타냅니다.
  let relationID: Int
  /// 현재 봉투를 주고받은 날짜를 나타냅니다.
  let date: Date
  /// 현재 봉투의 대상이되는 경조사에 참석 여부를 나타냅니다.
  let isVisited: Bool?
  /// 봉투의 선물을 나타냅니다.
  var gift: String?
  /// 봉투의 연락처를 나타냅니다.
  var contacts: String?
  /// 봉투의 메모를 나타냅니다.
  var memo: String?

  var priceText: String {
    return (CustomNumberFormatter.formattedByThreeZero(price) ?? "0") + "원"
  }

  var dateText: String {
    return CustomDateFormatter.getKoreanDateString(from: date)
  }

  var isVisitedText: String? {
    if let isVisited {
      return isVisited ? "예" : "아니오"
    }
    return nil
  }

  var eventNameTitle = "경조사"
  var nameTitle = "이름"
  var relationTitle = "나와의 관계"
  var dateTitle = "날짜"
  var visitedTitle = "방문여부"
  var giftTitle = "선물"
  var contactTitle = "연락처"
  var memoTitle = "메모"

  func makeListContent(isShowCategory: Bool) -> [(String, String)] {
    var res = isShowCategory ? [(eventNameTitle, eventName)] : []
    res.append(contentsOf: [
      (nameTitle, name),
      (relationTitle, relation),
      (dateTitle, dateText),
    ])
    res.append(contentsOf: makeOptionalListContent())
    return res
  }

  func makeOptionalListContent() -> [(String, String)] {
    var res: [(String, String)] = []
    if let isVisitedText {
      res.append((visitedTitle, isVisitedText))
    }
    if let gift {
      res.append((giftTitle, gift))
    }
    if let contacts {
      res.append((contactTitle, contacts))
    }
    if let memo {
      res.append((memoTitle, memo))
    }
    return res
  }

  init(
    id: Int64,
    type: String,
    ledgerID: Int64? = nil,
    price: Int64,
    eventName: String,
    eventID: Int,
    friendID: Int64,
    name: String,
    relation: String,
    relationID: Int,
    date: Date,
    isVisited: Bool?,
    gift: String? = nil,
    contacts: String? = nil,
    memo: String? = nil,
    eventNameTitle: String = "경조사",
    nameTitle: String = "이름",
    relationTitle: String = "나와의 관계",
    dateTitle: String = "날짜",
    visitedTitle: String = "방문여부",
    giftTitle: String = "선물",
    contactTitle: String = "연락처",
    memoTitle: String = "메모"
  ) {
    self.id = id
    self.type = type
    self.ledgerID = ledgerID
    self.price = price
    self.eventName = eventName
    self.eventID = eventID
    self.friendID = friendID
    self.name = name
    self.relation = relation
    self.relationID = relationID
    self.date = date
    self.isVisited = isVisited
    self.gift = gift
    self.contacts = contacts
    self.memo = memo
    self.eventNameTitle = eventNameTitle
    self.nameTitle = nameTitle
    self.relationTitle = relationTitle
    self.dateTitle = dateTitle
    self.visitedTitle = visitedTitle
    self.giftTitle = giftTitle
    self.contactTitle = contactTitle
    self.memoTitle = memoTitle
  }
}
