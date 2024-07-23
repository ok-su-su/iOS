//
//  OnboardingVotePersistencyHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog
import SSPersistancy

struct OnboardingVotePersistencyHelper: Equatable {
  func saveKeyChainIsNotInitialUser() {
    do {
      try SSKeychain.shared.save(key: Constants.isInitialUser, value: true)
    } catch {
      os_log("Bool을 data화하는데에 실패했습니다. ")
    }
  }

  enum Constants {
    static let isInitialUser: String = "InitialUser"
  }
}
