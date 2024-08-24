//
//  VotePreview.swift
//  SSVotePreview
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SSPersistancy
import SwiftUI
import Vote

@main
struct ToastPreviewMain: App {
  init() {
    Font.registerFont()
    FakeTokenManager.saveFakeToken(fakeToken: .uid5)
  }

  var body: some Scene {
    WindowGroup {
      VoteBuilder()
    }
  }
}
