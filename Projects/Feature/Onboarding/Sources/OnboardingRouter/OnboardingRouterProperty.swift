//
//  OnboardingRouterProperty.swift
//  Onboarding
//
//  Created by MaraMincho on 6/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSPersistancy

// MARK: - OnboardingRouterProperty

struct OnboardingRouterProperty: Equatable {}

extension OnboardingRouterProperty {
  func isInitialUser() -> Bool {
    SSKeychain.shared.load(key: Constants.isInitialUser) == nil
  }

  enum Constants {
    static let isInitialUser: String = "InitialUser"
  }
}
