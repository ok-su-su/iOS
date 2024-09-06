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
  case feedBack
  case privacyPolicy
  case appVersion
  case logout
  case resign
}

// MARK: - MyPageNavigationPath

@Reducer(state: .equatable, action: .equatable)
enum MyPageNavigationPath {
  case myPageInfo(MyPageInformation)
  case editMyPage(MyPageEdit)
}
