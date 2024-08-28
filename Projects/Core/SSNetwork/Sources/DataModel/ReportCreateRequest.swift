//
//  ReportCreateRequest.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct ReportCreateRequest: Encodable {
  /// Metadata ID
  public let metadataId: Int64
  /// 신고 대상 (Target ID)
  public let targetId: Int64
  /// 신고 대상 유형 (Target Type)
  public let targetType: String
  /// 신고 상세 설명 (Optional Description)
  public let description: String?

  public init(
    metadataId: Int64,
    targetId: Int64,
    targetType: ReportTargetType,
    description: String? = nil
  ) {
    self.metadataId = metadataId
    self.targetId = targetId
    self.targetType = targetType.description
    self.description = description
  }

  enum CodingKeys: CodingKey {
    case metadataId
    case targetId
    case targetType
    case description
  }
}
