//
//  SSEnvelopePreviewMain.swift
//  SSEnvelopePreview
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import Received
import SSPersistancy
import SwiftUI

@main
struct SSEnvelopePreviewMain: App {
  init() {
    Font.registerFont()
    FakeTokenManager.saveFakeToken(fakeToken: .uid5)
  }

  var body: some Scene {
    WindowGroup {
      VStack {
        Text("하이")
      }
    }
  }
}
