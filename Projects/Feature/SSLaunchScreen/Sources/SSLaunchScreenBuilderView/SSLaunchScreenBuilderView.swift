//
//  SSLaunchScreenBuilderView.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

public struct SSLaunchScreenBuilderView: View {
  public init() {}
  public var body: some View {
    LaunchScreenMainView(store: .init(initialState: LaunchScreenMain.State(), reducer: {
      LaunchScreenMain()
    }))
  }
}
