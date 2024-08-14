//
//  GetSafeAreaInsets.swift
//  Designsystem
//
//  Created by MaraMincho on 8/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

// MARK: - SafeAreaInsetsKey

struct SafeAreaInsetsKey: PreferenceKey {
  static var defaultValue = EdgeInsets()
  static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
    value = nextValue()
  }
}

public extension View {
  func getSafeAreaInsets(_ safeInsets: Binding<EdgeInsets>) -> some View {
    background(
      GeometryReader { proxy in
        Color.clear
          .preference(key: SafeAreaInsetsKey.self, value: proxy.safeAreaInsets)
      }
      .onPreferenceChange(SafeAreaInsetsKey.self) { value in
        safeInsets.wrappedValue = value
      }
    )
  }
}
