//
//  VoteWithCountResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct VoteWithCountResponse: Equatable, Codable{
  // 투표 아이디
  public let id: Int64
  public let board:  BoardModel
  // 내용
  public let content:String
  // 총 투표 수
  public let count: Int64
  // 수정 여부 (수정함 true, 안함 false)
  public let isModified: Bool
}
