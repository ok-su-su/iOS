//
//  SSCreateEnvelopeScreenPreview.swift
//  SSCreateEnvelopePreview
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SSCreateEnvelope
import SSPersistancy
import SwiftUI

@main
struct SSCreateEnvelopeScreenPreview: App {
  init() {
    Font.registerFont()
    FakeTokenManager.saveFakeToken(fakeToken: .uid5)
  }

  var body: some Scene {
    WindowGroup {
      CreateEnvelopeRouterBuilder(currentType: .received)
    }
  }
}
