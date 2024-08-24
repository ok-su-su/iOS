//
//  TCAMutexManager.swift
//  FeatureAction
//
//  Created by MaraMincho on 8/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - TaskManager

public struct TaskManager: Equatable {
  private let originalTaskCount: Int
  private var taskCount: Int
  public init(taskCount: Int) {
    self.taskCount = taskCount
    originalTaskCount = taskCount
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

public enum SingleTaskState {
  case willRun
  case didFinish
}
