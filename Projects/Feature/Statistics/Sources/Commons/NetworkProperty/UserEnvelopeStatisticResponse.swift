//
//  UserEnvelopeStatisticResponse.swift
//  Statistics
//
//  Created by MaraMincho on 8/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - UserEnvelopeStatisticResponse

struct UserEnvelopeStatisticResponse: Equatable, Decodable {
  /// 최근 사용 금액
  let recentSpent: [TitleValueModelLong]?
  /// 경조사를 가장 많이 쓴 달
  let mostSpentMonth: Int64?
  /// 가장 많이 쓴 관계
  let mostRelationship: TitleValueModelLong?
  /// 가장 많이 쓴 경조사
  let mostCategory: TitleValueModelLong?
  /// 가장 많이 받은 금액
  let highestAmountReceived: TitleValueModelLong?
  /// 가장 많이 보낸 금액
  let highestAmountSent: TitleValueModelLong?
}

extension UserEnvelopeStatisticResponse {
  static var emptyState: Self = .init(
    recentSpent: nil,
    mostSpentMonth: nil,
    mostRelationship: nil,
    mostCategory: nil,
    highestAmountReceived: nil,
    highestAmountSent: nil
  )
}

// MARK: - TitleValueModelLong

struct TitleValueModelLong: Equatable, Decodable {
  let title: String
  let value: Int64

  enum CodingKeys: CodingKey {
    case title
    case value
  }
}
