//
//  LanchScreenNetwork.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Moya
import SSInterceptor
import Foundation
import SSNetwork
import Dependencies

struct LaunchScreenNetwork {
  var getIsMandatoryUpdate: (_ version: String?)  async -> Bool
  private static func _getIsMandatoryUpdate(version: String?) async -> Bool {
    guard let version else {
      return false
    }
    do {
      let data: CheckApplicationVersionResponse = try await provider.request(.checkVersion(version: version))
      return data.needForceUpdate

    }
    /// network에러 발생시 일단 false 리턴을 통해 어플리케이션을 접근할 수 있도록 함
    catch {
      return false
    }
  }
}

extension LaunchScreenNetwork: DependencyKey {
  static var liveValue: LaunchScreenNetwork = .init(getIsMandatoryUpdate: _getIsMandatoryUpdate)

  static private let provider: MoyaProvider<Network> = .init()
  enum Network: SSNetworkTargetType {
    case checkVersion(version: String)
    var additionalHeader: [String : String]? { nil}

    var path: String {
      switch self {
      case .checkVersion(let version):
        "metadata/version"
      }
    }

    var method: Moya.Method {
      switch self {
      case .checkVersion:
          .get
      }
    }

    var task: Moya.Task {
      switch self {
      case let .checkVersion(version):
          .requestParameters(
            parameters: [
              "deviceOS": "IOS",
              "version": version
            ],
            encoding: URLEncoding.queryString
          )
      }
    }

  }
}

extension DependencyValues {
  var launchScreenNetwork: LaunchScreenNetwork {
    get { self [LaunchScreenNetwork.self] }
    set { self [LaunchScreenNetwork.self] = newValue }
  }
}
