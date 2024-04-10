//
//  Dependency+Target.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import ProjectDescription
import Foundation

public enum Shared: String {
  case writeBoard
  case mealTimer
  case profile
  case profileHamburger
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
}
public extension TargetDependency {
  static func shared(_ name: Shared) -> TargetDependency {
    return .external(name: name.rawValue, condition: .none)
  }
}
