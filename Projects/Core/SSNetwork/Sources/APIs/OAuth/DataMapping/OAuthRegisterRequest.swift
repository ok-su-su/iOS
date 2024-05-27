//
//  OAuthRegisterRequest.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct OAuthRegisterRequest: Encodable {
  private enum CodingKeys: String, CodingKey {
    case name
    case termAgreement
    case gender
    case birth
  }
  public var name: String
  public var termAgreement: [Int]
  public var gender: Gender
  public var birth: Int
}

extension OAuthRegisterRequest {
  public enum Gender: String, Encodable {
    case m = "M"
    case f = "F"
  }
}
