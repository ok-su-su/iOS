//
//  VotePreview.swift
//  SSVotePreview
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI
import Vote

@main
struct ToastPreviewMain: App {
  init() {
    Font.registerFont()
  }

  var body: some Scene {
    WindowGroup {
      VoteBuilder()
    }
  }
}
