//
//  MyPageRouterPath.swift
//  MyPage
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - MyPageRouterPath

enum MyPageRouterPath: Equatable {
  case myPageInformation
  case connectedSocialAccount
  case exportExcel
  case privacyPolicy
  case appVersion
  case logout
  case resign
  case feedBack
}

// MARK: - MyPageNavigationPath

@Reducer(state: .equatable, action: .equatable)
enum MyPageNavigationPath {
  case myPage(MyPageInformation)
  case editMyPage(MyPageEdit)
}
