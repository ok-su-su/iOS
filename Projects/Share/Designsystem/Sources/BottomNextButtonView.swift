//
//  BottomNextButtonView.swift
//  Designsystem
//
//  Created by MaraMincho on 7/21/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

// MARK: - BottomNextButtonView

public struct BottomNextButtonView: View {
  private let titleText: String
  private let action: () -> Void
  private let isActive: Bool

  public init(titleText: String, isActive: Bool, action: @escaping () -> Void) {
    self.titleText = titleText
    self.action = action
    self.isActive = isActive
  }

  public var body: some View {
    SSButtonWithState(
      .init(
        size: .mh60,
        status: isActive ? .active : .inactive,
        style: .filled,
        color: .black,
        buttonText: "다음",
        frame: .init(maxWidth: .infinity)
      )
    ) {
      action()
    }
    .background(isActive ? SSColor.gray100 : SSColor.gray30)
  }
}

public extension View {
  func addNextView(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
    safeAreaInset(edge: .bottom) {
      BottomNextButtonView(titleText: title, isActive: isActive, action: action)
    }
  }
}
