//
//  EnvelopeDetailProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct EnvelopeDetailProperty: Equatable, Identifiable {
  let id: UUID = .init()
  let price: Int
  let eventName: String
  let name: String
  let relation: String
  let date: Date
  let isVisited: Bool

  var gift: String?
  var contacts: String?
  var memo: String?

  var priceText: String {
    return (CustomNumberFormatter.formattedByThreeZero(price) ?? "0") + "원"
  }

  var dateText: String {
    return "2023년 11월 25일"
  }

  var isVisitedText: String {
    return isVisited ? "예" : "아니오"
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
    (visitedTitle, isVisitedText),
  ] + makeOptionalListContent() }

  func makeOptionalListContent() -> [(String, String)] {
    var res: [(String, String)] = []
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

  static func fakeData() -> Self {
    return [
      EnvelopeDetailProperty(price: 150_000, eventName: "돌잔치", name: "김민희", relation: "친구", date: .now, isVisited: true),
      EnvelopeDetailProperty(price: 1500, eventName: "결혼식", name: "김철수", relation: "친구", date: .now, isVisited: true),
      EnvelopeDetailProperty(price: 200_000, eventName: "장례식", name: "뉴진스", relation: "친구", date: .now, isVisited: true),
      EnvelopeDetailProperty(price: 150_000, eventName: "집들이", name: "블랙핑크", relation: "친구", date: .now, isVisited: true),
    ][Int.random(in: 0 ..< 4)]
  }

  /// 봉투의 상세 내용을 표시하기 위해 사용됩니다.
  /// - Parameters:
  ///   - price: 현재 봉투의 가격을 나타냅니다.
  ///   - eventName: 현재 봉투의 경조사 이름을 나타냅니다.
  ///   - name: 현재 봉투를 주고받은 대상의 이름을 나타냅니다.
  ///   - relation: 현재 봉투를 주고받은 사람과의 관계를 나타냅니다.
  ///   - date: 현재 봉투를 주고받은 날짜를 나타냅니다.
  ///   - isVisited: 현재 봉투의 대상이되는 경조사에 참석 여부를 나타냅니다.
  init(price: Int, eventName: String, name: String, relation: String, date: Date, isVisited: Bool) {
    self.price = price
    self.eventName = eventName
    self.name = name
    self.relation = relation
    self.date = date
    self.isVisited = isVisited
  }
}
