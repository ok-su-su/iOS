//
//  OnboardingBuilderView.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

public struct OnboardingBuilderView: View {
  public init() {}
  @State var show: Bool = true
  public var body: some View {
    OnboardingRouterView(store: .init(initialState: OnboardingRouter.State(), reducer: {
      OnboardingRouter()
    }))
  }
}
