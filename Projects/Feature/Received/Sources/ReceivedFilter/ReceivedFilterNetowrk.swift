//
//  ReceivedFilterNetowrk.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - ReceivedFilterNetwork

struct ReceivedFilterNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  func requestFilterItems() async throws -> [FilterSelectableItemProperty] {
    let data: CreateEnvelopesConfigResponse = try await provider.request(.getFilterItems)
    var res: [FilterSelectableItemProperty] = data.categories.sorted(by: { $0.seq < $1.seq })
    _ = res.popLast()
    return res
  }
}

extension DependencyValues {
  var receivedFilterNetwork: ReceivedFilterNetwork {
    get { self[ReceivedFilterNetwork.self] }
    set { self[ReceivedFilterNetwork.self] = newValue }
  }
}

// MARK: - ReceivedFilterNetwork + DependencyKey

extension ReceivedFilterNetwork: DependencyKey {
  static var liveValue: ReceivedFilterNetwork = .init()

  private enum Network: SSNetworkTargetType {
    case getFilterItems

    var additionalHeader: [String: String]? { nil }

    var path: String { "envelopes/configs/create-envelopes" }

    var method: Moya.Method { .get }

    var task: Moya.Task { .requestPlain }
  }
}
