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

  var priceText: String {
    return CustomNumberFormatter.formattedByThreeZero(price) ?? "0원"
  }

  var dateText: String {
    return "2023년 11월 25일"
  }

  var isVisitedText: String {
    return isVisited ? "예" : "아니오"
  }

  var makeListContent: [(String, String)] { [
    ("경조사", eventName),
    ("이름", name),
    ("나와의 관계", relation),
    ("날짜", dateText),
    ("방문여부", isVisitedText),
  ] }

  static func fakeData() -> Self {
    return [
      EnvelopeDetailProperty(price: 150_000, eventName: "돌잔치", name: "김민희", relation: "친구", date: .now, isVisited: true),
      EnvelopeDetailProperty(price: 1500, eventName: "결혼식", name: "김철수", relation: "친구", date: .now, isVisited: true),
      EnvelopeDetailProperty(price: 200_000, eventName: "장례식", name: "뉴진스", relation: "친구", date: .now, isVisited: true),
      EnvelopeDetailProperty(price: 150_000, eventName: "집들이", name: "블랙핑크", relation: "친구", date: .now, isVisited: true),
    ][Int.random(in: 0 ..< 4)]
  }
}
