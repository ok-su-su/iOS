//
//  ReportCreateResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct ReportCreateResponse {
  /// 신고 히스토리 id (History ID)
  public let historyId: Int64
  /// 신고 메타데이터 id (Metadata ID)
  public let metadataId: Int64

  public init(historyId: Int64, metadataId: Int64) {
    self.historyId = historyId
    self.metadataId = metadataId
  }
}
