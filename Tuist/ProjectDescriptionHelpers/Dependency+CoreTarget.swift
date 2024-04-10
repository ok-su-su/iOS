//
//  Dependency+Target.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

public enum Core: String {
  case writeBoard
  public var targetName: String {
    return rawValue.prefix(1).capitalized
  }
  public var path: Path {
    return .relativeToRoot("Projects/Core/\(self.targetName)/")
  }
}

public extension TargetDependency {
  static func core(_ name: Core) -> TargetDependency {
    return .project(target: name.targetName, path: name.path, condition: .none)
  }
}