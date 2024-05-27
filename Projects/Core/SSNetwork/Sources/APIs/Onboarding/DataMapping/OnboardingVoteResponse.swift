//
//  OnboardinVoteResponse.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct OnboardingVoteResponse: Decodable {
  private enum CondingKeys: String, CodingKey {
    case options
  }
  public var options: [OnboardingVoteOptionCountModel]
}

extension OnboardingVoteResponse {
  public struct OnboardingVoteOptionCountModel: Decodable {
    private enum CodingKeys: String, CodingKey {
      case content
      case count
    }
    public var content: String
    public var count: Int
  }
}
