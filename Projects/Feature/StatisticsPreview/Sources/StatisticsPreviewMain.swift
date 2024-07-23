//
//  StatisticsPreviewMain.swift
//  StatisticsPreview
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import Statistics
import SwiftUI

@main
struct StatisticsPreviewMain: App {
  init() {
    Font.registerFont()
  }

  var body: some Scene {
    WindowGroup {
      StatisticsBuilderView()
    }
  }
}
