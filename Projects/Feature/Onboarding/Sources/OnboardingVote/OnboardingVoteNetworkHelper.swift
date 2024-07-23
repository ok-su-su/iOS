//
//  OnboardingVoteNetworkHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya
import SSNetwork

// MARK: - OnboardingNetworkHelper

struct OnboardingNetworkHelper: Equatable {
  private enum Network: SSNetworkTargetType {
    case getOnboardingVoteList
    var additionalHeader: [String: String]? { nil }
    var path: String { "api/v1/votes/onboarding" }
    var method: Moya.Method { return .get }
    var task: Moya.Task { return .requestPlain }
  }

  func getOnboardingVoteItems() async -> [OnboardingVoteItem] {
    let provider = MoyaProvider<Network>()
    do {
      let responseDTO: GetOnboardingVoteListResponseDTO = try await provider.request(.getOnboardingVoteList)
      return responseDTO.toOnboardingVoteItem()
    } catch {
      return .initialItems()
    }
  }
}

// MARK: - GetOnboardingVoteListResponseDTO

struct GetOnboardingVoteListResponseDTO: Codable {
  let options: [Option]

  func toOnboardingVoteItem() -> [OnboardingVoteItem] {
    return options.enumerated().map { .init(title: $0.element.content, id: $0.offset) }
  }
}

// MARK: - Option

struct Option: Codable {
  /// Vote Item Title
  let content: String
  /// ?
  let count: Int
}
