//
//  HealthCheckTargetType.swift
//  SSInterceptor
//
//  Created by MaraMincho on 6/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya
import SSNetwork

// MARK: - HealthCheck

struct HealthCheck: SSNetworkTargetType {
  init() {}
  var additionalHeader: [String: String]? { nil }
  var path: String { "healthh" }
  var method: Moya.Method { .get }
  var task: Moya.Task { .requestPlain }
}

// MARK: - healthCheckResponseDTO

struct healthCheckResponseDTO: Decodable {
  let env: String
  let dateTime: String
  let message: String
}
