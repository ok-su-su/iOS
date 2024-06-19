//
//  SSNetworkTargetType.swift
//  SSNetwork
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya

// MARK: - SSNetworkTargetType

public protocol SSNetworkTargetType: TargetType {
  var additionalHeader: [String: String]? { get }
}

public extension SSNetworkTargetType {
  var baseURL: URL {
    guard
      let urlString = Bundle.main.infoDictionary?[XCConfigKey.BaseURL.key] as? String,
      let targetURL = URL(string: urlString)
    else {
      fatalError("BaseURL을 생성할 수 없습니다. XCConfig를 확인해주세요")
    }
    return targetURL
  }

  var validationType: ValidationType {
    .successCodes
  }

  var headers: [String: String]? {
    var additionalHeader = additionalHeader ?? .init()
    DefaultHeaderValue.allCases.forEach { current in
      additionalHeader[current.key] = current.value
    }
    return additionalHeader
  }
}

// MARK: - XCConfigKey

enum XCConfigKey: String {
  case BaseURL

  var key: String {
    return rawValue
  }
}

// MARK: - DefaultHeaderValue

enum DefaultHeaderValue: String, CaseIterable {
  case contentType

  var value: String {
    switch self {
    case .contentType:
      return "application/json"
    }
  }

  var key: String {
    switch self {
    case .contentType:
      return "Content-type"
    }
  }
}
