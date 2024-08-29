//
//  CreateLedgerNetwork.swift
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

// MARK: - CreateLedgerNetwork

struct CreateLedgerNetwork {
  private let network = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  /// 기타 아이템도 포함하여 전달합니다.
  func getCreateLedgerCategoryItem() async throws -> [CreateLedgerCategoryItem] {
    let data: CreateEnvelopesConfigResponse = try await network.request(.getCategories)
    return data.categories.sorted { $0.seq < $1.seq }
  }

  func createLedgers(_ data: Data) async throws {
    try await network.request(.createLedgers(data))
  }
}

extension DependencyValues {
  var createLedgerNetwork: CreateLedgerNetwork {
    get { self[CreateLedgerNetwork.self] }
    set { self[CreateLedgerNetwork.self] = newValue }
  }
}

// MARK: - CreateLedgerNetwork + DependencyKey

extension CreateLedgerNetwork: DependencyKey {
  static var liveValue: CreateLedgerNetwork = .init()
  private enum Network: SSNetworkTargetType {
    case getCategories
    case createLedgers(Data)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getCategories:
        "envelopes/configs/create-envelopes"
      case .createLedgers:
        "ledgers"
      }
    }

    var method: Moya.Method {
      switch self {
      case .getCategories:
        .get
      case .createLedgers:
        .post
      }
    }

    var task: Moya.Task {
      switch self {
      case .getCategories:
        return .requestPlain
      case let .createLedgers(data):
        return .requestData(data)
      }
    }
  }
}
