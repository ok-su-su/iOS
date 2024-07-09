//
//  SSLaunchScreenBuilderView.swift
//  SSLaunchScreen
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

public struct SSLaunchScreenBuilderView: View {
  @State var store: StoreOf<LaunchScreenMain> = .init(initialState: .init()) {
    LaunchScreenMain()
  }

  public init() {}
  public var body: some View {
    LaunchScreenMainView(store: store)
  }
}
