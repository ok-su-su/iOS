//
//  OnboardingLoginNetworkHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Dependencies
import Foundation
import KakaoLogin
import Moya
import OSLog
import SSNetwork
import SSPersistancy

// MARK: - OnboardingLoginNetworkHelper

struct OnboardingLoginNetworkHelper: Sendable {
  private nonisolated(unsafe) let provider: MoyaProvider<Network> = .init()
  func loginWithKakao() async -> Bool {
    return await LoginWithKakao.loginWithKakao()
  }

  func isNewUser(loginType: LoginType, token: String) async -> Bool {
    do {
      os_log("새로운 유저인지 확인합니다. loginType: \(loginType.rawValue) \n token : \(token)")
      let newUserDTO: isNewUserResponseDTO = try await provider.request(.isNewUser(loginType, token))
      return newUserDTO.canRegister
    } catch {
      os_log("가입가능한지에 대한 리스폰스처리 에러 입니다.\n \(error.localizedDescription)")
      return true
    }
  }

  func loginWithSUSU(loginType: LoginType, token: String) async {
    do {
      let tokenData = try JSONEncoder().encode(LoginWithSUSUBodyDTO(accessToken: token))
      let susuToken: SignUpResponseDTO = try await provider.request(.loginWithSUSU(loginType, tokenData))
      try SSTokenManager.shared.saveToken(
        SSToken(
          accessToken: susuToken.accessToken,
          accessTokenExp: susuToken.accessTokenExp,
          refreshToken: susuToken.refreshToken,
          refreshTokenExp: susuToken.refreshTokenExp
        )
      )
    } catch {
      os_log("loginWithSUSUError \(#function) \(error)")
    }
  }

  init() {}
}

// MARK: DependencyKey

extension OnboardingLoginNetworkHelper: DependencyKey {
  static let liveValue: OnboardingLoginNetworkHelper = .init()
  private enum Network: SSNetworkTargetType {
    case isNewUser(LoginType, String)
    case loginWithSUSU(LoginType, Data)
    var additionalHeader: [String: String]? {
      nil
    }

    var path: String {
      switch self {
      case let .isNewUser(loginType, _):
        os_log("요청 URL: oauth/\(loginType.rawValue)/sign-up/valid")
        return "oauth/\(loginType)/sign-up/valid"
      case let .loginWithSUSU(loginType, _):
        return "oauth/\(loginType)/login"
      }
    }

    var method: Moya.Method {
      switch self {
      case .isNewUser:
        .get
      case .loginWithSUSU:
        .post
      }
    }

    var task: Moya.Task {
      switch self {
      case let .isNewUser(_, token):
        return .requestParameters(parameters: ["accessToken": token], encoding: URLEncoding.queryString)
      case let .loginWithSUSU(_, tokenData):
        return .requestData(tokenData)
      }
    }
  }
}

extension DependencyValues {
  var onBoardingLoginNetwork: OnboardingLoginNetworkHelper {
    get { self[OnboardingLoginNetworkHelper.self] }
    set { self[OnboardingLoginNetworkHelper.self] = newValue }
  }
}

// MARK: - LoginWithSUSUBodyDTO

struct LoginWithSUSUBodyDTO: Encodable {
  let accessToken: String
}

// MARK: - isNewUserResponseDTO

struct isNewUserResponseDTO: Decodable {
  /// 새로운 고객은 가입할 수 있다.
  /// isNewUser == canRegister
  let canRegister: Bool
}
