//
//  SSToastModifier.swift
//  SSToast
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct SSToastModifier: ViewModifier {
  var toastStore: StoreOf<SSToast>
  public func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(alignment: .bottom) {
        SSToastView(store: toastStore)
      }
  }
  public init(toastStore: StoreOf<SSToast>) {
    self.toastStore = toastStore
  }
}
