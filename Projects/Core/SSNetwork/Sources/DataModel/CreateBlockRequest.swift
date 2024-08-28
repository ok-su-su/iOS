//
//  CreateBlockRequest.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct CreateBlockRequest: Encodable {
  /// 차단 타겟 id (Target ID)
  public let targetId: Int64
  /// 차단 타겟 타입 (Target Type)
  public let targetType: UserBlockTargetType
  /// 차단 이유 (Optional Reason)
  public let reason: String?

  public init(
    targetId: Int64,
    targetType: UserBlockTargetType,
    reason: String? = nil
  ) {
    self.targetId = targetId
    self.targetType = targetType
    self.reason = reason
  }

  enum CodingKeys: CodingKey {
    case targetId
    case targetType
    case reason
  }
}
