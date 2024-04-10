//
//  Dependency+Target.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

public enum ThirdParty: String {
  case Alamofire
  public var targetName: String {
    switch self {
    case .Alamofire :
      return "Alamofire"
    }
  }
}

public extension TargetDependency {
  static func thirdParty(_ name: ThirdParty) -> TargetDependency {
    return .external(name: name.rawValue, condition: .none)
  }
}
