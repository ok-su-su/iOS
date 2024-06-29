//
//  MyPageSharedState.swift
//  MyPage
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final class MyPageSharedState {
  private init() {}

  static let shared = MyPageSharedState()

  /// 저장된 UserInfoResponseDTO를 가져옵니다.
  func getMyUserInfoDTO() -> UserInfoResponseDTO? {
    return info
  }

  func setUserInfoResponseDTO(_ val: UserInfoResponseDTO) {
    info = val
  }

  private var info: UserInfoResponseDTO?
}
