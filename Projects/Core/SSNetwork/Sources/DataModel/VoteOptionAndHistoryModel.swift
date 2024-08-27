//
//  VoteOptionAndHistoryModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct VoteOptionAndHistoryModel: Equatable, Decodable {
  /// 투표 옵션 id
  public let id: Int64
  /// 투표 id
  public let postId: Int64
  /// 옵션 내용
  public let content: String
  /// 순서
  public let seq: Int
  /// 투표 여부
  public let isVoted: Bool

  enum CodingKeys: CodingKey {
    case id
    case postId
    case content
    case seq
    case isVoted
  }
}
