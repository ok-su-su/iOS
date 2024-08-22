//
//  MyPageSharedState.swift
//  MyPage
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import SSNetwork
import SSNotification

final class MyPageSharedState {
  private init() {
    addObserver()
  }

  func addObserver() {
    NotificationCenter.default.addObserver(forName: SSNotificationName.goMainScene, object: nil, queue: .main) { _ in
      self.info = nil
    }
  }

  static let shared = MyPageSharedState()

  /// 저장된 UserInfoResponseDTO를 가져옵니다.
  func getMyUserInfoDTO() -> UserInfoResponse? {
    return info
  }

  func setUserInfoResponseDTO(_ val: UserInfoResponse) {
    info = val
  }

  private var info: UserInfoResponse?

  func getVersion() -> String {
    return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
  }
}
