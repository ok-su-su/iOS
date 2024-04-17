//
//  RootView.swift
//  SSRoot
//
//  Created by MaraMincho on 4/17/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

public struct RootView: View {
  @Bindable var store: StoreOf<RootViewFeature>
  public var body: some View {
    NavigationView {
      HeaderView()
    }
  }

  public init(store: StoreOf<RootViewFeature>) {
    self.store = store
  }
}
