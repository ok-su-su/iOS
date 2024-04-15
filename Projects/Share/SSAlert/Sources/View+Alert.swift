//
//  View+Alert.swift
//  SSAlert
//
//  Created by MaraMincho on 4/14/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import SwiftUI

public extension View {
  func customAlert(
    isPresented: Binding<Bool>,
    messageAlertProperty: MessageAlertProperty
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      MessageAlert(messageAlertProperty, isPresented: isPresented)
        .presentationBackground(.clear)
    }
    .transaction { transaction in
      if isPresented.wrappedValue {
        transaction.disablesAnimations = true
        transaction.animation = .linear(duration: 0.1)
      }
    }
  }
}
