//
//  SliceResponseDtoVoteAndOptionsWithCountResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct SliceResponseDtoVoteAndOptionsWithCountResponse: Equatable, Decodable {
  public let data: [VoteAndOptionsWithCountResponse]
  public let page: Int32?
  public let size: Int32?
  public let sort: SortObject
  public let hasNext: Bool

  enum CodingKeys: CodingKey {
    case data
    case page
    case size
    case sort
    case hasNext
  }
}
