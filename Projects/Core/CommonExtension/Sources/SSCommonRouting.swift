//
//  SSCommonRouting.swift
//  CommonExtension
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import OSLog
import UIKit

public enum SSCommonRouting {
  @MainActor
  public static func openAppStore() {
    guard let appID = Bundle.main.infoDictionary?["AppstoreAPPID"] as? String,
          let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
          UIApplication.shared.canOpenURL(appStoreURL)
    else {
      os_log("앱스토어 실행하지 않습니다.")
      return
    }
    os_log("앱스토어를 실행합니다.")
    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
  }
}
