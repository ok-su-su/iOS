//
//  Dependency+ThirdParty.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 4/8/24.
//

import Foundation
import ProjectDescription

// MARK: - ThirdParty

public enum ThirdParty: String, CaseIterable {
  case Moya
  case ComposableArchitecture
  case RealmSwift
  case Realm
  public var targetName: String {
    switch self {
    default:
      return rawValue
    }
  }

  private var productType: Product {
    switch self {
    default:
      return .framework
    }
  }

  public static var allCasesProductType: [String: Product] {
    var res: [String: Product] = [:]
    Self.allCases.forEach { res[$0.rawValue] = $0.productType }
    return res
  }
}

public extension TargetDependency {
  static func thirdParty(_ name: ThirdParty) -> TargetDependency {
    return .external(name: name.rawValue, condition: .none)
  }
}
