//
//  CreateVoteRequest.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct CreateVoteRequest: Equatable, Encodable {
  /// 투표 컨텐트
  public let content: String
  /// 투표 옵션
  public let options: [VoteOptionModel]
  /// 보드 아이디
  public let boardId: Int64

  enum CodingKeys: CodingKey {
    case content
    case options
    case boardId
  }

  public init(content: String, options: [VoteOptionModel], boardId: Int64) {
    self.content = content
    self.options = options
    self.boardId = boardId
  }
}


