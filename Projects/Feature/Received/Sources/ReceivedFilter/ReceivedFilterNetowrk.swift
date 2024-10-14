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

struct ReceivedFilterNetwork: Sendable {
  var requestFilterItems: @Sendable () async throws -> [FilterSelectableItemProperty]
  @Sendable private static func _requestFilterItems() async throws -> [FilterSelectableItemProperty] {
    let data: CreateEnvelopesConfigResponse = try await provider.request(.getFilterItems)
    let sortedCategories = data.categories.sorted(by: { $0.seq < $1.seq })
    let res = sortedCategories.map {
      FilterSelectableItemProperty(
        id: Int64($0.id),
        seq: $0.seq,
        name: $0.name,
        style: $0.style,
        isActive: $0.isActive,
        isCustom: $0.isCustom,
        isMiscCategory: $0.isMiscCategory
      )
    }
    return res
  }
}

// MARK: DependencyKey

extension ReceivedFilterNetwork: DependencyKey {
  private nonisolated(unsafe) static let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  static let liveValue: ReceivedFilterNetwork = .init(
    requestFilterItems: _requestFilterItems
  )

  private enum Network: SSNetworkTargetType {
    case getFilterItems

    var additionalHeader: [String: String]? { nil }

    var path: String { "envelopes/configs/create-envelopes" }

    var method: Moya.Method { .get }

    var task: Moya.Task { .requestPlain }
  }
}

extension DependencyValues {
  var receivedFilterNetwork: ReceivedFilterNetwork {
    get { self[ReceivedFilterNetwork.self] }
    set { self[ReceivedFilterNetwork.self] = newValue }
  }
}
