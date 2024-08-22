//
//  PageResponseDtoSearchEnvelopeResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct PageResponseDtoSearchEnvelopeResponse: Equatable, Codable {
  public let data: [SearchEnvelopeResponse]
  public let page: Int?
  public let size: Int?
  public let totalPage: Int
  public let totalCount: Int
  public let sort: SortObject

  enum CodingKeys: String, CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}
