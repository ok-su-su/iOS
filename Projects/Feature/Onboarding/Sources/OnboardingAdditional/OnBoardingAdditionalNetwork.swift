//
//  OnBoardingAdditionalNetwork.swift
//  Onboarding
//
//  Created by MaraMincho on 6/17/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import AppleLogin
import Foundation
import KakaoLogin
import Moya
import OSLog
import SSNetwork

// MARK: - OnBoardingAdditionalNetwork

struct OnBoardingAdditionalNetwork: Equatable {
  static func == (_: OnBoardingAdditionalNetwork, _: OnBoardingAdditionalNetwork) -> Bool {
    return true
  }

  enum Network: SSNetworkTargetType {
    case signupByKakao(SingUpBodyDTOData: Data, token: String)
    case signupByApple(SingUpBodyDTOData: Data, token: String)

    var additionalHeader: [String: String]? { nil }
    var path: String {
      switch self {
      case .signupByKakao:
        return "oauth/KAKAO/sign-up"
      case .signupByApple:
        return "oauth/APPLE/sign-up"
      }
    }

    var method: Moya.Method {
      .post
    }

    var task: Moya.Task {
      switch self {
      case let .signupByKakao(singUpBodyDTO, token):
        return .requestCompositeData(bodyData: singUpBodyDTO, urlParameters: ["accessToken": token])
      case let .signupByApple(singUpBodyDTO, token):
        return .requestCompositeData(bodyData: singUpBodyDTO, urlParameters: ["accessToken": token])
      }
    }
  }

  private let provider: MoyaProvider<Network> = .init()

  func requestSignUp(body: SignUpBodyProperty) async throws -> SignUpResponseDTO {
    let bodyData = try body.makeBodyData()
    switch body.getLoginType() {
    case .KAKAO:
      guard let token = LoginWithKakao.getToken() else {
        throw OnboardingSignUpError.tokenError
      }
      return try await provider.request(.signupByKakao(SingUpBodyDTOData: bodyData, token: token))

    case .APPLE:
      let bodyData = try body.makeBodyData()
      guard let token = LoginWithApple.identityToken else {
        throw OnboardingSignUpError.tokenError
      }
      return try await provider.request(.signupByApple(SingUpBodyDTOData: bodyData, token: token))

    case .GOOGLE:
      throw OnboardingSignUpError.notImplementLoginMethod("Google")

    case .none:
      throw OnboardingSignUpError.requestBodyIsInvalid
    }
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
  case requestBodyIsInvalid
  case notImplementLoginMethod(String)

  var errorDescription: String? {
    switch self {
    case .tokenError:
      return "토큰값이 유효하지 않습니다."
    case .requestBodyIsInvalid:
      return "요청하는 Body값이 잘못되었습니다."
    case let .notImplementLoginMethod(val):
      return "\(val) Login Method가 구현되지 않았습니다. "
    }
  }
}
