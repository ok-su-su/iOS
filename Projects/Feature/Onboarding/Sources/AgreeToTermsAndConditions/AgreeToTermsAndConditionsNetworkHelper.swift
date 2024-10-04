//
//  AgreeToTermsAndConditionsNetworkHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/16/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import Moya
import SSNetwork

// MARK: - AgreeToTermsAndConditionsNetwork

struct AgreeToTermsAndConditionsNetwork: Sendable {
  private nonisolated(unsafe) static let provider: MoyaProvider<TermsTarget> = .init()

  var requestTermsInformation: @Sendable () async throws -> GetTermsInformationResponseDTO
  private static func _requestTermsInformation() async throws -> GetTermsInformationResponseDTO {
    return try await provider.request(.getTermsInformation)
  }

  var requestTermsInformationDetail: @Sendable (_ id: Int) async throws -> GetTermsInformationDetailResponseDTO
  private static func _requestTermsInformationDetail(_ id: Int) async throws -> GetTermsInformationDetailResponseDTO {
    return try await provider.request(.getTermsInformationDetail(id: id))
  }

  private enum TermsTarget: SSNetworkTargetType {
    case getTermsInformation
    case getTermsInformationDetail(id: Int)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .getTermsInformation:
        return "terms"
      case let .getTermsInformationDetail(id):
        return "terms/\(id)"
      }
    }

    var method: Moya.Method {
      .get
    }

    var task: Moya.Task {
      return .requestPlain
    }
  }
}

// MARK: DependencyKey

extension AgreeToTermsAndConditionsNetwork: DependencyKey {
  static let liveValue: AgreeToTermsAndConditionsNetwork = .init(
    requestTermsInformation: _requestTermsInformation,
    requestTermsInformationDetail: _requestTermsInformationDetail
  )
}

extension DependencyValues {
  var agreeToTermsAndConditionsNetwork: AgreeToTermsAndConditionsNetwork {
    get { self[AgreeToTermsAndConditionsNetwork.self] }
    set { self[AgreeToTermsAndConditionsNetwork.self] = newValue }
  }
}

// MARK: - GetTermsInformationResponseElement

struct GetTermsInformationResponseElement: Codable {
  let id: Int
  let title: String
  let isEssential: Bool
}

typealias GetTermsInformationResponseDTO = [GetTermsInformationResponseElement]

// MARK: - GetTermsInformationDetailResponseDTO

struct GetTermsInformationDetailResponseDTO: Codable, Sendable {
  let id: Int
  let title, description: String
  let isEssential: Bool
}
