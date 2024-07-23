//
//  TapAndEndEditing.swift
//  Designsystem
//
//  Created by MaraMincho on 7/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import SwiftUI

private extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

public extension TextField {
  func onReturnKeyPressed(textFieldText text: String, _ action: @escaping (String) -> Void) -> some View {
    modifier(ReturnKeyHandler(text: text, action: action))
  }
}

// MARK: - ReturnKeyHandler

struct ReturnKeyHandler: ViewModifier {
  var action: (String) -> Void
  var text: String
  init(text: String, action: @escaping (String) -> Void) {
    self.action = action
    self.text = text
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: text) { _, newValue in
        var newValue = newValue
        guard let newValueLastChar = newValue.last else { return }
        if newValueLastChar == "\n" {
          _ = newValue.popLast()
          action(newValue)
        }
      }
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
