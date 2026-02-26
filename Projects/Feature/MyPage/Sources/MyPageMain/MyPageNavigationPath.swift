//
//  MyPageNavigationPath.swift
//  MyPage
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

// MARK: - MyPageNavigationPath

@CasePathable
@Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
enum MyPageNavigationPath {
  case myPageInfo(MyPageInformation)
  case editMyPage(MyPageEdit)
}
