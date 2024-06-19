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
    ZStack {
      if isLoading {
        let filePath = Bundle(for: ForBundleFinderClass.self).path(forResource: "SSLoading", ofType: "json")!
        ZStack {
          Color.clear
          LottieView(animation: .filepath(filePath))
            .looping()
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 72, height: 72)
            .clipped()
        }

      } else {
        content
      }
    }
  }
}
