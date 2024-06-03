//
//  Dependency+shareTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

// MARK: - Shared

public enum Shared: String {
  case designsystem
  case sSAlert
  case sSToast
  case sSLayout
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }

  public var path: Path {
    return .relativeToRoot("Projects/Share/\(targetName)/")
  }
}

public extension TargetDependency {
  static func share(_ name: Shared) -> TargetDependency {
    return .project(target: name.targetName, path: name.path, condition: .none)
  }
}
