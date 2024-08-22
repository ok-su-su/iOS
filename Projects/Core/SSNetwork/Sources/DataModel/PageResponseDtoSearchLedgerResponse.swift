//
//  PageResponseDtoSearchLedgerResponse.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PageResponseDtoSearchLedgerResponse

public struct PageResponseDtoSearchLedgerResponse: Codable {
  public let data: [SearchLedgerResponse]
  public let page: Int?
  public let size: Int?
  public let totalPage: Int
  public let totalCount: Int
  public let sort: SortObject

  enum CodingKeys: CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}
