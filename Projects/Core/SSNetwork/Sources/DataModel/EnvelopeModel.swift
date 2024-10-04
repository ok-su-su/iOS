//
//  EnvelopeModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct EnvelopeModel: Codable, Equatable, Sendable {
  ///  봉투 id
  public let id: Int64
  /// user id, 소유자
  public let uid: Int64
  /// Sent or RECIVED
  public let type: String
  /// 금액
  public let amount: Int64
  /// 선물
  public let gift: String?
  /// 메모
  public let memo: String?
  /// 방문여부
  public let hasVisited: Bool?
  /// 전달 일
  public let handedOverAt: String

  enum CodingKeys: String, CodingKey {
    case id
    case uid
    case type
    case amount
    case gift
    case memo
    case hasVisited
    case handedOverAt
  }
}
