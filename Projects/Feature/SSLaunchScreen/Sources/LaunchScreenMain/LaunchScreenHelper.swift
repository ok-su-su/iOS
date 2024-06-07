//
//  LaunchScreenHelper.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct LaunchScreenHelper {
  init() {}

  func runAppInitTask() async -> EndedLaunchScreenStatus {
    // TODO: Must be delete
    sleep(2)
    return .newUser
  }
}
