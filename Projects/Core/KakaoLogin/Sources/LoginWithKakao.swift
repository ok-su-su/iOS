//
//  LoginWithKakao.swift
//  KakaoLogin
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import OSLog

// MARK: - LoginWithKakao

public enum LoginWithKakao {
  /// 카카오로 소셜 로그인 합니다.
  @MainActor
  public static func loginWithKakao() async -> Bool {
    return await withCheckedContinuation { continuation in
      if isKAKAOInstalled() {
        loginWithKAKAOTalk { value in continuation.resume(returning: value) }
      } else {
        loginWithWeb { value in continuation.resume(returning: value) }
      }
    }
  }

  /// 카카오톡이 설치되었는지 확인합니다.
  public static func isKAKAOInstalled() -> Bool {
    return UserApi.isKakaoTalkLoginAvailable()
  }

  /// 카카오톡으로 로그인 합니다.
  public static func loginWithKAKAOTalk(completion: @escaping (Bool) -> Void) {
    UserApi.shared.loginWithKakaoTalk { _, error in
      if let error {
        os_log("\(error)")
        completion(false)
      } else {
        os_log("loginWithKakaoTalk() success., \(#function), \(#line)")
        completion(true)
      }
    }
  }

  /// 웹에서 카카오 계정을 Access합니다.
  public static func loginWithWeb(completion: @escaping (Bool) -> Void) {
    UserApi.shared.loginWithKakaoAccount { _, error in
      if let error {
        os_log("\(error)")
      } else {
        os_log("loginWithWeb() success., \(#function), \(#line)")
        completion(true)
      }
    }
  }

  public static func checkKakaoToken() async -> Bool {
    return await withCheckedContinuation { promise in
      if (AuthApi.hasToken()) {
        UserApi.shared.accessTokenInfo { (_, error) in
          if let error = error {
            promise.resume(with: .success(false))
            if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
              os_log("invalidTokkenError, sdkInvalidTokkenError가 발생했습니다.")
            }
            else {
              os_log("기타 카카오 로그인 에러가 발생했습니다. ")
            }
          }
          else {
            promise.resume(with: .success(true))
          }
        }
      }
      // AccessToken이 없습니다. 로그인이 필요합니다.
      else {
        promise.resume(with: .success(false))
      }
    }
  }

  /// "카카오 토큰을 가져옵니다."
  /// - Returns: optional KakaoToken
  ///
  /// 토큰이 없을 경우 Nil 을 리턴합니다.
  public static func getToken() -> String? {
    return TokenManager.manager.getToken()?.accessToken
  }

  /// KAKAOSDK를 초기화 합니다.
  public static func initKakaoSDK() {
    guard let appKey = Bundle.main.infoDictionary?["NATIVE_APP_KEY"] as? String else {
      os_log("NativeAppKey를 가져오는데에 실패했습니다.")
      return
    }
    os_log("KakaoNativeAppKey를 정상적으로 가져왔습니다.")
    KakaoSDK.initSDK(appKey: appKey)
  }
}

// MARK: - SUSUKakaoLoginError

enum SUSUKakaoLoginError: LocalizedError {
  case invalidToken
  case loginError

  var errorDescription: String? {
    switch self {
    case .invalidToken:
      return NSLocalizedString("invalidToken", comment: "토큰값이 유효하지 않습니다.")
    case .loginError:
      return NSLocalizedString("loginError", comment: "카카오 로그인을 해야 합니다.")
    }
  }
}
