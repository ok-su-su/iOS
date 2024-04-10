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
  case mealTimer
  case profile
  case profileHamburger
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
}

public extension TargetDependency {
  static func feature(_ name: Shared) -> TargetDependency {
    return .external(name: name.rawValue, condition: .none)
  }
}
