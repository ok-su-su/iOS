//
//  OnboardingRouterPublisher.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

struct OnboardingRouterPublisher {
  static var shared = OnboardingRouterPublisher()
  private init() {}
  private var pathPublisher: PassthroughSubject<OnboardingRouter.Path.State, Never> = .init()

  func send(_ value: OnboardingRouter.Path.State) {
    pathPublisher.send(value)
  }

  func publisher() -> AnyPublisher<OnboardingRouter.Path.State, Never> {
    return pathPublisher.eraseToAnyPublisher()
  }
}
