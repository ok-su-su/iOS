//
//  TCAMutex.swift
//  FeatureAction
//
//  Created by MaraMincho on 9/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog
import SwiftAsyncMutex

public typealias TCAMutex = AsyncMutexManager

public extension TCAMutex {
  func waitForFinish(minimumTimeDuration: Double = 0.3) async {
    // Start Point
    let initTime = Date()
    await waitForFinish()

    // End Point
    let elapsedTime = Date().timeIntervalSince(initTime)
    if elapsedTime < minimumTimeDuration {
      let remainingTime = minimumTimeDuration - elapsedTime
      do {
        try await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
      } catch {
        os_log("error occurred\n\(error.localizedDescription)")
      }
    }
  }
}
