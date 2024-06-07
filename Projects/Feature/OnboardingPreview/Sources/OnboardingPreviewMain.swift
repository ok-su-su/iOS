//
//  OnboardingPreviewMain.swift
//  OnboardingPreview
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import Onboarding
import SwiftUI

@main
struct OnboardingPreviewMain: App {
  var body: some Scene {
    WindowGroup {
      OnboardingBuilderView()
        .onAppear {
          Font.registerFont()
          // MARK: - ConstraintsError없애는 코드
          #if DEBUG
            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
          #endif
        }
    }
  }
}
