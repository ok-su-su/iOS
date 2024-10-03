//
//  LanchScreenNetwork.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
@preconcurrency import Moya
import OSLog
import SSInterceptor
import SSNetwork

// MARK: - LaunchScreenNetwork

struct LaunchScreenNetwork: Sendable {
  var getIsMandatoryUpdate: @Sendable (_ version: String?) async -> Bool
  @Sendable private static func _getIsMandatoryUpdate(version: String?) async -> Bool {
    guard let version else {
      os_log("버전이 올바르지 않습니다. ")
      return false
    }
    do {
      let data: CheckApplicationVersionResponse = try await provider.request(.checkVersion(version: version))
      os_log("현재 어플리케이션 버전 : \(version), \(data.needForceUpdate ? "강제 업데이트가 필요합니다." : "강제 업데이트가 필요하지 않습니다.") ")
      return data.needForceUpdate
    }
    // network에러 발생시 일단 false 리턴을 통해 어플리케이션을 접근할 수 있도록 함
    catch {
      return false
    }
  }
}

// MARK: DependencyKey

extension LaunchScreenNetwork: DependencyKey {
  static let liveValue: LaunchScreenNetwork = .init(getIsMandatoryUpdate: _getIsMandatoryUpdate)

  private static let provider: MoyaProvider<Network> = .init()
  enum Network: SSNetworkTargetType {
    case checkVersion(version: String)
    var additionalHeader: [String: String]? { nil }

    var path: String {
      switch self {
      case .checkVersion:
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
            "version": version,
          ],
          encoding: URLEncoding.queryString
        )
      }
    }
  }
}

extension DependencyValues {
  var launchScreenNetwork: LaunchScreenNetwork {
    get { self[LaunchScreenNetwork.self] }
    set { self[LaunchScreenNetwork.self] = newValue }
  }
}
