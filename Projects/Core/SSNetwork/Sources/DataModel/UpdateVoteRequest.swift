//
//  UpdateVoteRequest.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct UpdateVoteRequest: Encodable, Equatable {
  public let boardID: Int64
  public let content: String

  public init(boardID: Int64, content: String) {
    self.boardID = boardID
    self.content = content
  }
}
