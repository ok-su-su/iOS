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
  /// 카카오톡이 설치되었는지 확인합니다.
  public static func isKAKAOInstalled() -> Bool {
    return UserApi.isKakaoTalkLoginAvailable()
  }

  /// 카카오톡으로 로그인 합니다.
  public static func loginWithKAKAOTlak(completion: @escaping (Bool) -> Void) {
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
            // 로그인 필요
          } else {
            // 기타 에러
          }
        } else {
          // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
        }
      }
    } else {
      os_log("로그인 필요")
    }
  }

  /// KAKAOSDK를 초기화 합니다.
  public static func initKakaoSDK() {
    KakaoSDK.initSDK(appKey: "${NATIVE_APP_KEY}")
  }
}
