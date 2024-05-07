//
//  Dependency+Target.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

public enum Feature: String {
  case writeBoard
  case sent
  case inventory
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
  public var path: Path {
    return .relativeToRoot("Projects/Feature/\(self.targetName)/")
  }
}

public extension TargetDependency {
  static func feature(_ name: Feature) -> TargetDependency {
    return .project(target: name.targetName, path: name.path, condition: .none)
  }
}
