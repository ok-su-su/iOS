//
//  GetFriendStatisticsResponse.swift
//  SSNetwork
//
//  Created by MaraMincho on 8/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
// MARK: - SearchFriendsResponseDataDTO

/// 친구 검색 화면에 사용되는 ResponseDTO입니다. 친구가 누가 있는지 그리고 검색을 위해 활용됩니다.
public struct GetFriendStatisticsResponse: Codable, Equatable {
  public let friend: FriendModel
  public let totalAmounts: Int64
  public let sentAmounts: Int64
  public let receivedAmounts: Int64

  enum CodingKeys: CodingKey {
    case friend
    case totalAmounts
    case sentAmounts
    case receivedAmounts
  }
}
