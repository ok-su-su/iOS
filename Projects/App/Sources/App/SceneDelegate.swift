//
//  SceneDelegate.swift
//  susu
//
//  Created by MaraMincho on 4/10/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import KakaoLogin
import KakaoSDKAuth
import UIKit

// MARK: - MySceneDelegate

class MySceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
  }

  func sceneDidDisconnect(_: UIScene) {}

  func sceneDidBecomeActive(_: UIScene) {}

  func sceneWillResignActive(_: UIScene) {}

  // MARK: - Tells the delegate that the scene is about to begin running in the foreground and become visible to the user.

  func sceneWillEnterForeground(_: UIScene) {
//    SSTimeOut.enterForegroundScreen()
  }

  // MARK: - Tells the delegate that the scene is running in the background and is no longer onscreen.

  func sceneDidEnterBackground(_: UIScene) {
//    SSTimeOut.enterBackground()
  }
}

// MARK: - KAKAO OAuth2.0 Extension

extension MySceneDelegate {
  func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      if AuthApi.isKakaoTalkLoginUrl(url) {
        _ = AuthController.handleOpenUrl(url: url)
      }
    }
  }
}
