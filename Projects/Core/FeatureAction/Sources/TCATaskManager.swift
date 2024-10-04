//
//  TCATaskManager.swift
//  FeatureAction
//
//  Created by MaraMincho on 8/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - TCATaskManager

public struct TCATaskManager: Equatable, Sendable {
  private let originalTaskCount: Int
  private var taskCount: Int
  public init(taskCount: Int) {
    self.taskCount = taskCount
    originalTaskCount = taskCount
  }

  public init() {
    let targetTaskCount = 0
    taskCount = targetTaskCount
    originalTaskCount = targetTaskCount
  }

  public mutating func task(_ state: SingleTaskState) {
    switch state {
    case .didFinish:
      taskDidFinish()
    case .willRun:
      taskWillRun()
    }
  }

  public mutating func taskWillRun() {
    taskCount -= 1
  }

  public mutating func taskDidFinish() {
    taskCount += 1
  }

  public mutating func isEndOfTask() -> Bool {
    originalTaskCount == taskCount
  }

  public mutating func isRunningTask() -> Bool {
    !(originalTaskCount == taskCount)
  }
}

// MARK: - SingleTaskState

public enum SingleTaskState: Sendable {
  case willRun
  case didFinish
}
