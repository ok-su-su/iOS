//
//  AppDelegate.swift
//  susu
//
//  Created by MaraMincho on 4/10/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Designsystem
import FirebaseCore
import SwiftUI
import UIKit

class MyAppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    Font.registerFont()
    #if !DEBUG
      FirebaseApp.configure()
    #endif
    return true
  }

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options _: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    sceneConfig.delegateClass = MySceneDelegate.self
    return sceneConfig
  }
}
