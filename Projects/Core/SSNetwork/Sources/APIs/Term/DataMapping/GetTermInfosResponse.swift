//
//  GetTermInfosResponse.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct GetTermInfosResponse: Decodable {
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case isEssential
  }
  public var id: Int
  public var title: String
  public var isEssential: Bool
}
