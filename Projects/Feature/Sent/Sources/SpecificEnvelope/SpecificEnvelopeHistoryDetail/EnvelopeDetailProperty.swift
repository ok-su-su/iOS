//
//  EnvelopeDetailProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct EnvelopeDetailProperty: Equatable, Identifiable {
  /// 봉투의 아이디 입니다.
  let id: Int
  /// 현재 봉투의 가격을 나타냅니다.
  let price: Int
  /// 현재 봉투의 경조사 이름을 나타냅니다.
  let eventName: String
  /// 봉투를 받은 사람의 이름을 나타냅니다.
  let name: String
  ///  현재 봉투를 주고받은 사람과의 관계를 나타냅니다.
  let relation: String
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

  var makeListContent: [(String, String)] { [
    (eventNameTitle, eventName),
    (nameTitle, name),
    (relationTitle, relation),
    (dateTitle, dateText),
  ] + makeOptionalListContent() }

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

  /// 봉투의 상세 내용을 표시하기 위해 사용됩니다.
  /// - Parameters:
  ///   - id: 봉투의 아이디 입니다.
  ///   - price: 현재 봉투의 가격을 나타냅니다.
  ///   - eventName: 현재 봉투의 경조사 이름을 나타냅니다.
  ///   - name: 현재 봉투를 주고받은 대상의 이름을 나타냅니다.
  ///   - relation: 현재 봉투를 주고받은 사람과의 관계를 나타냅니다.
  ///   - date: 현재 봉투를 주고받은 날짜를 나타냅니다.
  ///   - isVisited: 현재 봉투의 대상이되는 경조사에 참석 여부를 나타냅니다.
  init(id: Int, price: Int, eventName: String, name: String, relation: String, date: Date, isVisited: Bool?, gift: String? = nil, contacts: String? = nil, memo: String? = nil) {
    self.id = id
    self.price = price
    self.eventName = eventName
    self.name = name
    self.relation = relation
    self.date = date
    self.isVisited = isVisited
    self.gift = gift
    self.contacts = contacts
    self.memo = memo
  }
}
