//
//  SentPreviewMain.swift
//  SentPreview
//
//  Created by MaraMincho on 6/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import Sent
import SwiftUI

@main
struct SentPreviewMain: App {
  init() {
    Font.registerFont()
  }

  var body: some Scene {
    WindowGroup {
      SentBuilderView()
    }
  }
}
