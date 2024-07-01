//
//  CreateLedgerCategoryNetwork.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSInterceptor
import SSNetwork

// MARK: - CreateLedgerCategoryNetwork

struct CreateLedgerCategoryNetwork {
  private let network = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  /// 기타 아이템도 포함하여 전달합니다.
  func getCreateLedgerCategoryItem() async throws -> [CreateLedgerCategoryItem] {
    let data: CreateEnvelopesConfigResponse = try await network.request(.getCategories)
    return data.categories.map { .init(title: $0.name, id: $0.id) }
  }
}

extension DependencyValues {
  var createLedgerCategoryNetwork: CreateLedgerCategoryNetwork {
    get { self[CreateLedgerCategoryNetwork.self] }
    set { self[CreateLedgerCategoryNetwork.self] = newValue }
  }
}

// MARK: - CreateLedgerCategoryNetwork + DependencyKey

extension CreateLedgerCategoryNetwork: DependencyKey {
  static var liveValue: CreateLedgerCategoryNetwork = .init()
  private enum Network: SSNetworkTargetType {
    case getCategories

    var additionalHeader: [String: String]? { nil }
    var path: String { "envelopes/configs/create-envelopes" }
    var method: Moya.Method { .get }
    var task: Moya.Task { .requestPlain }
  }
}
