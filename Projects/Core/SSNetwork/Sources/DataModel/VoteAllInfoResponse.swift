//
//  VoteAllInfoResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct VoteAllInfoResponse: Equatable, Decodable {
  /// 투표 id
  public let id: Int64
  /// 본인 소유 글 여부 / 내 글 : 1, 전체 글 : 0
  public let isMine: Bool
  /// 보드
  public let board: BoardModel
  /// 내용
  public let content: String
  /// 총 투표 수
  public let count: Int64
  /// 생성일
  public let createdAt: String
  /// 생성자 profile
  public let creatorProfile: UserProfileModel
  /// 수정 여부 / 수정함 : true, 수정 안함 : false
  public let isModified: Bool
  /// 투표 옵션
  public let options: [VoteOptionCountModel]

  enum CodingKeys: CodingKey {
    case id
    case isMine
    case board
    case content
    case count
    case createdAt
    case creatorProfile
    case isModified
    case options
  }
}
