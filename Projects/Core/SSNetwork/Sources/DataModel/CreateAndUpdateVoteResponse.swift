//
//  CreateAndUpdateVoteResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct CreateAndUpdateVoteResponse: Equatable, Decodable {
  /// 투표 id
  public let id: Int64
  /// 본인 소유 글 여부 / 내 글 : true, 전체 글 : false
  public let isMine: Bool
  /// 투표 생성자 id
  public let uid: Int64
  /// 보드
  public let board: BoardModel
  /// 내용
  public let content: String
  /// 수정 여부 / 수정함 : true, 수정 안함 : false
  public let isModified: Bool
  /// 투표 옵션
  public let options: [VoteOptionAndHistoryModel]
  /// 투표 생성일
  public let createdAt: String

  enum CodingKeys: CodingKey {
    case id
    case isMine
    case uid
    case board
    case content
    case isModified
    case options
    case createdAt
  }
}
