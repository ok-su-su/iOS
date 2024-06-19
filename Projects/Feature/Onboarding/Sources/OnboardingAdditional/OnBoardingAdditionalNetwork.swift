//
//  OnBoardingAdditionalNetwork.swift
//  Onboarding
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import KakaoLogin
import Moya
import SSNetwork

// MARK: - OnBoardingAdditionalNetwork

struct OnBoardingAdditionalNetwork: Equatable {
  static func == (_: OnBoardingAdditionalNetwork, _: OnBoardingAdditionalNetwork) -> Bool {
    return true
  }

  enum Network: SSNetworkTargetType {
    case signupByKakao(SingUpBodyDTOData: Data, token: String)
    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .signupByKakao:
        return "oauth/KAKAO/sign-up"
      }
    }

    var method: Moya.Method {
      switch self {
      case .signupByKakao:
        return .post
      }
    }

    var task: Moya.Task {
      switch self {
      case let .signupByKakao(singUpBodyDTO, token):
        return .requestCompositeData(bodyData: singUpBodyDTO, urlParameters: ["accessToken": token])
      }
    }
  }

  private let provider: MoyaProvider<Network> = .init()

  func requestSignUp(body: Data) async throws -> SignUpResponseDTO {
    guard let token = LoginWithKakao.getToken() else {
      throw OnboardingSignUpError.tokenError
    }
    return try await provider.request(.signupByKakao(SingUpBodyDTOData: body, token: token))
  }
}

// MARK: - SingUpBodyDTO

struct SingUpBodyDTO: Equatable, Encodable {
  var name: String
  var termAgreement: [Int]
  var gender: String?
  var birth: Int?

  init(name: String, termAgreement: [Int], gender: String? = nil, birth: Int? = nil) {
    self.name = name
    self.termAgreement = termAgreement
    self.gender = gender
    self.birth = birth
  }
}

// MARK: - SignUpResponseDTO

struct SignUpResponseDTO: Decodable {
  let accessToken, accessTokenExp, refreshToken, refreshTokenExp: String
}

// MARK: - OnboardingSignUpError

enum OnboardingSignUpError: LocalizedError {
  case tokenError

  var errorDescription: String? {
    switch self {
    case .tokenError:
      return "토큰값이 유효하지 않습니다."
    }
  }
}
