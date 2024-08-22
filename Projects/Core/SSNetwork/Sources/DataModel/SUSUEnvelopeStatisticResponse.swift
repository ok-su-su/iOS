//
//  SUSUEnvelopeStatisticResponse.swift
//  Statistics
//
//  Created by MaraMincho on 8/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SUSUEnvelopeStatisticResponse

public struct SUSUEnvelopeStatisticResponse: Decodable, Equatable {
  /// 평균 보낸 비용
  public let averageSent: Int64?

  public let averageRelationship: TitleValueModelLong?
  public let averageCategory: TitleValueModelLong?
  public let recentSpent: [TitleValueModelLong]?
  public let mostSpentMonth: Int64?
  public let mostRelationship: TitleValueModelLong?
  public let mostCategory: TitleValueModelLong?

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

public extension SUSUEnvelopeStatisticResponse {
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
