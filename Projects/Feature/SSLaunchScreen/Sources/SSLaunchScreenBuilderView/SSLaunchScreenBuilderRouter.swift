//
//  SSLaunchScreenBuilderRouter.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

// MARK: - SSLaunchScreenBuilderRouterPublisher

public final class SSLaunchScreenBuilderRouterPublisher {
  private init() {}

  private let statusPublisher: PassthroughSubject<LaunchStatus, Never> = .init()
  public func publisher() -> AnyPublisher<LaunchStatus, Never> {
    return statusPublisher.eraseToAnyPublisher()
  }

  public func send(_ value: LaunchStatus) {
    statusPublisher.send(value)
  }
}

// MARK: - LaunchStatus

public enum LaunchStatus: Equatable {
  case launchTaskWillRun
  case launchTaskDidRun(EndedLaunchScreenStatus)
}

// MARK: - EndedLaunchScreenStatus

public enum EndedLaunchScreenStatus: Equatable {
  case newUser
  case prevUser
}
