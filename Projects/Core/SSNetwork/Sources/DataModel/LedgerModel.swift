//
//  LedgerModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - LedgerModel

public struct LedgerModel: Codable {
  /// Ledger ID
  public let id: Int64
  /// 장부 이름
  public let title: String
  /// 장부 상세 설명
  public let description: String?
  /// 장부 시작일
  public let startAt: String
  /// 장부 종료일
  public let endAt: String

  enum CodingKeys: CodingKey {
    case id
    case title
    case description
    case startAt
    case endAt
  }
}
