//
//  FloatingButtonView.swift
//  Designsystem
//
//  Created by MaraMincho on 7/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

// MARK: - FloatingButtonView

public struct FloatingButtonView: View {
  // MARK: Content

  let completion: () -> Void
  public init(completion: @escaping () -> Void) {
    self.completion = completion
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      SSImage.commonAdd
    }
    .padding(12)
    .frame(width: 48, height: 48, alignment: .center)
    .background(SSColor.gray100)
    .cornerRadius(100)
    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 8)
    .onTapGesture {
      completion()
    }
  }

  public var body: some View {
    makeContentView()
  }
}

// MARK: - FloatingButtonModifier

public struct FloatingButtonModifier: ViewModifier {
  let tapAction: () -> Void
  public init(tapAction: @escaping () -> Void) {
    self.tapAction = tapAction
  }

  public func body(content: Content) -> some View {
    content
      .overlay(alignment: .bottomTrailing) {
        FloatingButtonView(completion: tapAction)
          .padding(.all, 20)
      }
  }
}

public extension View {
  func ssFloatingButton(tapAction: @escaping () -> Void) -> some View {
    modifier(FloatingButtonModifier(tapAction: tapAction))
  }
}
