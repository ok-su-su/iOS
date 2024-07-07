//
//  SSToastModifier.swift
//  SSToast
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - SSToastModifier

@available(*, deprecated, renamed: "showToast(StoreOf:)", message: "Use extension of view function")
public struct SSToastModifier: ViewModifier {
  var toastStore: StoreOf<SSToastReducer>
  public func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(alignment: .bottom) {
        SSToastView(store: toastStore)
          .padding(.horizontal, 24)
      }
  }

  public init(toastStore: StoreOf<SSToastReducer>) {
    self.toastStore = toastStore
  }
}

public extension View {
  func showToast(store: StoreOf<SSToastReducer>) -> some View {
    modifier(SSToastModifier(toastStore: store))
  }
}
