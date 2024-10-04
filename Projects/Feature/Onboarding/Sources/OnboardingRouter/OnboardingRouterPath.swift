//
//  OnboardingRouterPath.swift
//  Onboarding
//
//  Created by MaraMincho on 10/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - OnboardingRouterPath

@Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
enum OnboardingRouterPath {
  case vote(OnboardingVote)
  case login(OnboardingLogin)
  case terms(AgreeToTermsAndConditions)
  case termDetail(TermsAndConditionDetail)
  case registerName(OnboardingRegisterName)
  case additional(OnboardingAdditional)
}
