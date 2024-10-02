//
//  EnvelopeDetailProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork

public typealias EnvelopeDetailProperty = EnvelopeDetailResponse

extension EnvelopeDetailProperty {
  var eventNameTitle: String { "경조사" }
  var nameTitle: String { "이름" }
  var relationTitle: String { "나와의 관계" }
  var dateTitle: String { "날짜" }
  var visitedTitle: String { "방문여부" }
  var giftTitle: String { "선물" }
  var contactTitle: String { "연락처" }
  var memoTitle: String { "메모" }

  var priceText: String {
    return (CustomNumberFormatter.formattedByThreeZero(envelope.amount) ?? "0") + "원"
  }

  var dateText: String {
    let date = CustomDateFormatter.getDate(from: envelope.handedOverAt) ?? .now
    return CustomDateFormatter.getKoreanDateString(from: date)
  }

  func makeListContent(isShowCategory: Bool) -> [(String, String)] {
    let categoryName = category.customCategory ?? category.category
    var res = isShowCategory ? [(eventNameTitle, categoryName)] : []
    res.append(contentsOf: [
      (nameTitle, friend.name),
      (relationTitle, relationship.relation),
      (dateTitle, dateText),
    ])
    res.append(contentsOf: makeOptionalListContent())
    return res
  }

  func makeOptionalListContent() -> [(String, String)] {
    var res: [(String, String)] = []
    if let hasVisited = envelope.hasVisited {
      let visitedText: String = hasVisited ? "예" : "아니오"
      res.append((visitedTitle, visitedText))
    }
    if let gift = envelope.gift {
      res.append((giftTitle, gift))
    }
    if let contacts = friend.phoneNumber {
      res.append((contactTitle, contacts))
    }
    if let memo = envelope.memo {
      res.append((memoTitle, memo))
    }
    return res
  }
}
