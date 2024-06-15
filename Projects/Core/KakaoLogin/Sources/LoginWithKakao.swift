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

  public static func checkKakaoToken() {
    if AuthApi.hasToken() {
      UserApi.shared.accessTokenInfo { _, error in
        if let error {
          if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
            os_log("로그인이 필요합니다.")
            // 로그인 필요
          } else {
            os_log("기타 에러")
            // 기타 에러
          }
        } else {
          os_log("토큰이 갱신됨 (성공)")
          // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
        }
      }
    } else {
      os_log("로그인 필요")
    }
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
