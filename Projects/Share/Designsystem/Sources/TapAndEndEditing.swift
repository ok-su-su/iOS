//
//  TapAndEndEditing.swift
//  Designsystem
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

private extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

public extension View {
  func whenTapDismissKeyboard() -> some View {
    modifier(TapOutsideDismissKeyBoardModifier())
  }
}

// MARK: - TapOutsideDismissKeyBoardModifier

struct TapOutsideDismissKeyBoardModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onTapGesture {
        UIApplication.shared.endEditing()
      }
  }
}
