//
//  StatisticsPreviewMain.swift
//  StatisticsPreview
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SSPersistancy
import Statistics
import SwiftUI

@main
struct StatisticsPreviewMain: App {
  init() {
    Font.registerFont()
    FakeTokenManager.saveFakeToken(fakeToken: .uid5)
  }

  var body: some Scene {
    WindowGroup {
      StatisticsBuilderView()
    }
  }
}
