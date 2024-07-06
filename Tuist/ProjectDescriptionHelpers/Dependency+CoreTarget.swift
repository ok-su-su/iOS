//
//  Dependency+CoreTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

// MARK: - Core

public enum Core: String {
  case sSNetwork
  case sSDataBase
  case sSRoot
  case kakaoLogin
  case sSPersistancy
  case coreLayers
  case sSInterceptor
  case featureAction
  case sSRegexManager
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }

  public var path: Path {
    return .relativeToRoot("Projects/Core/\(targetName)/")
  }
}

public extension TargetDependency {
  static func core(_ name: Core) -> TargetDependency {
    return .project(target: name.targetName, path: name.path, condition: .none)
  }
}
