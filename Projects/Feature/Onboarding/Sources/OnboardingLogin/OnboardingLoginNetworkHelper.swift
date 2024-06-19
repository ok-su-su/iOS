//
//  OnboardingLoginNetworkHelper.swift
//  Onboarding
//
//  Created by MaraMincho on 6/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import KakaoLogin
import Moya
import OSLog
import SSNetwork
import SSPersistancy

// MARK: - OnboardingLoginNetworkHelper

struct OnboardingLoginNetworkHelper: Equatable {
  static func == (_: OnboardingLoginNetworkHelper, _: OnboardingLoginNetworkHelper) -> Bool {
    return true
  }

  private enum Network: SSNetworkTargetType {
    case isNewUser(LoginType, String)
    case loginWithSUSU(LoginType, Data)
    var additionalHeader: [String: String]? {
      nil
    }

    var path: String {
      switch self {
      case let .isNewUser(loginType, _):
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

  private let provider: MoyaProvider<Network> = .init()
  func loginWithKakao() async -> Bool {
    return await LoginWithKakao.loginWithKakao()
  }

  func isNewUser(loginType: LoginType) async -> Bool {
    guard let token = getTokenFormManager(loginType) else {
      os_log("Oauth의 저장된 토큰이 없습니다. 심각한 오류 입니다. \(#function)")
      return true
    }

    do {
      let newUserDTO: isNewUserResponseDTO = try await provider.request(.isNewUser(loginType, token))
      return newUserDTO.canRegister
    } catch {
      os_log("가입가능한지에 대한 리스폰스처리 에러 입니다.\n \(error.localizedDescription)")
      return true
    }
  }

  func loginWithSUSU(loginType: LoginType) async {
    guard let token = getTokenFormManager(loginType) else {
      os_log("저장된 토큰이 없습니다. \(#function)")
      return
    }

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
      os_log("loginWIthSUSUError \(#function) \(error)")
    }
  }

  private func getTokenFormManager(_ type: LoginType) -> String? {
    switch type {
    case .KAKAO:
      return LoginWithKakao.getToken()
    case .APPLE:
      fatalError("로그인 방식이 구현되지 않았습니다.")
    case .GOOGLE:
      fatalError("로그인 방식이 구현되지 않았습니다.")
    }
  }

  init() {}
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
