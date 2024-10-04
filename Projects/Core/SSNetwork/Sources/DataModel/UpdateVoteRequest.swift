//
//  UpdateVoteRequest.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct UpdateVoteRequest: Encodable, Sendable {
  /// 보드 id
  public let boardID: Int64
  ///   투표 내용
  public let content: String

  enum CodingKeys: String, CodingKey {
    case boardID = "boardId"
    case content
  }

  public init(boardID: Int64, content: String) {
    self.boardID = boardID
    self.content = content
  }
}
