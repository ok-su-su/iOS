//
//  SSLoadingView.swift
//  Designsystem
//
//  Created by MaraMincho on 6/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Lottie
import OSLog
import SwiftUI

// MARK: - ForBundleFinderClass

final class ForBundleFinderClass {}

// MARK: - SSLoadingModifier

public struct SSLoadingModifier: ViewModifier {
  var isLoading: Bool

  public init(isLoading: Bool) {
    self.isLoading = isLoading
  }

  public func body(content: Content) -> some View {
    let filePath = Bundle(for: ForBundleFinderClass.self).path(forResource: "SSLoading", ofType: "json")!

    ZStack(alignment: .center) {
      content
        .opacity(isLoading ? 0 : 1)
      if isLoading {
        LottieView(animation: .filepath(filePath))
          .looping()
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 72, height: 72)
          .clipped()
      }
    }
  }
}

public extension View {
  func ssLoading(_ isLoading: Bool) -> some View {
    modifier(SSLoadingModifier(isLoading: isLoading))
  }
}

// MARK: - SSLoadingModifierWithOverlay

public struct SSLoadingModifierWithOverlay: ViewModifier {
  var isLoading: Bool

  public init(isLoading: Bool) {
    self.isLoading = isLoading
  }

  public func body(content: Content) -> some View {
    content
      .allowsHitTesting(!isLoading)
      .overlay {
        if isLoading {
          let filePath = Bundle(for: ForBundleFinderClass.self).path(forResource: "SSLoading", ofType: "json")!
          ZStack {
            Color
              .gray100
              .opacity(0.3)
            LottieView(animation: .filepath(filePath))
              .looping()
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 72, height: 72)
              .clipped()
          }
        }
      }
  }
}
