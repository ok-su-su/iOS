//
//  SentPreviewMain.swift
//  SentPreview
//
//  Created by MaraMincho on 6/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import Sent
import SSPersistancy
import SwiftUI

@main
struct SentPreviewMain: App {
  init() {
    Font.registerFont()
    FakeTokenManager.saveFakeToken(fakeToken: .uid5)
  }

  var body: some Scene {
    WindowGroup {
      SentBuilderView()
    }
  }
}
