//
//  OnboardingPreviewMain.swift
//  OnboardingPreview
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import KakaoLogin
import KakaoSDKAuth
import Onboarding
import SwiftUI

@main
struct OnboardingPreviewMain: App {
  init() {
    LoginWithKakao.initKakaoSDK()
  }

  var body: some Scene {
    WindowGroup {
      OnboardingBuilderView().onOpenURL(perform: { url in
        if AuthApi.isKakaoTalkLoginUrl(url) {
          AuthController.handleOpenUrl(url: url)
        }
      })
      .onAppear {
        Font.registerFont()

        // MARK: - ConstraintsError없애는 코드

        #if DEBUG
          UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        #endif
      }
    }
  }
}
