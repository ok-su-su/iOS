//
//  VoteAndOptionsWithCountResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct VoteAndOptionsWithCountResponse: Equatable, Decodable {
  /// 투표 id
  public let id: Int64
  /// 투표 생성자 id
  public let uid: Int64

  /// 본인 글 소유 여부, 내 글 : true, 남 글 : false
  public let isMine: Bool
  public let board: BoardModel
  /// 내용
  public let content: String
  /// 수정 여부 / 수정함 : true, 수정 안함 : false
  public let isModified: Bool

  /// 총 투표 수
  public let count: Int64

  /// 투표 옵션
  public let options: [VoteOptionModel]
  /// 투표 생성일
  public let createdAt: String
}
