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

  func sceneWillEnterForeground(_: UIScene) {}

  func sceneDidEnterBackground(_: UIScene) {}
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
