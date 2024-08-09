//
//  SUSUEnvelopeStatisticResponse.swift
//  Statistics
//
//  Created by MaraMincho on 8/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SUSUEnvelopeStatisticResponse

struct SUSUEnvelopeStatisticResponse: Decodable, Equatable {
  /// 평균 보낸 비용
  let averageSent: Int64?

  let averageRelationship: TitleValueModelLong?
  let averageCategory: TitleValueModelLong?
  let recentSpent: [TitleValueModelLong]?
  let mostSpentMonth: Int64?
  let mostRelationship: TitleValueModelLong?
  let mostCategory: TitleValueModelLong?

  enum CodingKeys: CodingKey {
    case averageSent
    case averageRelationship
    case averageCategory
    case recentSpent
    case mostSpentMonth
    case mostRelationship
    case mostCategory
  }
}

extension SUSUEnvelopeStatisticResponse {
  static var emptyState: Self {
    .init(
      averageSent: nil,
      averageRelationship: nil,
      averageCategory: nil,
      recentSpent: nil,
      mostSpentMonth: nil,
      mostRelationship: nil,
      mostCategory: nil
    )
  }
}

extension SUSUEnvelopeStatisticResponse {
  var averageSentLabel: String {
    CustomNumberFormatter.toDecimal(averageSent) ?? "50,000" + "원"
  }
}
