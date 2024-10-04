//
//  VoteOptionWithoutIdModel.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

/// 투표 옵션 내용 (id 제외) 모델
public struct VoteOptionWithoutIdModel: Encodable, Equatable, Sendable {
  /// 옵션 내용
  public let content: String
  /// 순서
  public let seq: Int

  public init(content: String, seq: Int) {
    self.content = content
    self.seq = seq
  }
}
