//
//  Dependency+FeatureTarget.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

// MARK: - Feature

public enum Feature: String {
  case sent
  case received
  case myPage
  case vote
  case sSSearch
  case statistics
  case onboarding
  case sSLaunchScreen
  case appleLogin
  case sSSelectableItems
  case sSCreateEnvelope
  case sSEnvelope
  case sSEditSingleSelectButton
  public var targetName: String {
    return rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }

  public var path: Path {
    return .relativeToRoot("Projects/Feature/\(targetName)/")
  }
}

public extension TargetDependency {
  static func feature(_ name: Feature) -> TargetDependency {
    return .project(target: name.targetName, path: name.path, condition: .none)
  }
}
