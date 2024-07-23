//
//  PageResponseDtoGetFriendStatisticsResponse.swift
//  Received
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SearchFriendsResponseDTO

struct PageResponseDtoGetFriendStatisticsResponse: Codable, Equatable {
  let data: [GetFriendStatisticsResponse]
  let page: Int?
  let size: Int?
  let totalPage: Int
  let totalCount: Int
  let sort: SortObject

  enum CodingKeys: String, CodingKey {
    case data
    case page
    case size
    case totalPage
    case totalCount
    case sort
  }
}
