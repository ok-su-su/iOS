//
//  VoteOptionModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

/// 투표 옵션 모델
public struct VoteOptionModel: Equatable, Codable {
  /// 투표 옵션 아이디
  public let id: Int64
  /// 투표 id
  public let postId: Int64
  /// 옵션 내용
  public let content: String
  /// 순서
  public let seq: Int32
}
