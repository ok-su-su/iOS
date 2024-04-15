//
//  Dependency+Target.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

public enum ThirdParty: String, CaseIterable {
  case Moya
  public var targetName: String {
    switch self {
    case .Moya:
      return "Moya"
    }
  }
  
  private var productType: Product {
    switch self {

    default:
      return .framework
    }
  }
  
  static public var allCasesProductType: [String: Product] {
    var res: [String: Product] = [:]
    Self.allCases.forEach{res[$0.rawValue] = $0.productType}
    return res
  }
}

public extension TargetDependency {
  static func thirdParty(_ name: ThirdParty) -> TargetDependency {
    return .external(name: name.rawValue, condition: .none)
  }
}
