//
//  SSFireBase.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import FirebaseAnalytics
import SwiftUI

public extension View {
  func ssAnalyticsScreen(
    moduleName name: MarketingModulesMain,
    class: String = "View",
    extraParameters: [String: Any] = [:]
  ) -> some View {
    analyticsScreen(name: name.description, class: `class`, extraParameters: extraParameters)
  }
}
