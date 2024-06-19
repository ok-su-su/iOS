//
//  AgreeToTermsAndConditionsNetworkHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/16/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya
import SSNetwork

// MARK: - AgreeToTermsAndConditionsNetworkHelper

struct AgreeToTermsAndConditionsNetworkHelper: Equatable {
  static func == (_: AgreeToTermsAndConditionsNetworkHelper, _: AgreeToTermsAndConditionsNetworkHelper) -> Bool {
    return true
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

  private let provider: MoyaProvider<TermsTarget> = .init()

  func requestTermsInformation() async throws -> GetTermsInformationResponseDTO {
    return try await provider.request(.getTermsInformation)
  }

  func requestTermsInformationDetail(id: Int) async throws -> GetTermsInformationDetailResponseDTO {
    return try await provider.request(.getTermsInformationDetail(id: id))
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

struct GetTermsInformationDetailResponseDTO: Codable {
  let id: Int
  let title, description: String
  let isEssential: Bool
}
