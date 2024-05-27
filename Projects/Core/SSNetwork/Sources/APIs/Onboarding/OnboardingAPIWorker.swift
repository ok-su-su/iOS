//
//  OnboardingAPIWorker.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final public class OnboardingAPIWorker: Networkable {
  
  // MARK: - Typealias
  typealias Target = OnboardingTarget
  
  // MARK: - Provider
  lazy var provider = makeUnauthProvider()
  
  // MARK: - Networking
  public func onboarding() async throws -> OnboardingVoteResponse {
    try await provider.request(.onboarding, of: OnboardingVoteResponse.self)
  }
  
}
