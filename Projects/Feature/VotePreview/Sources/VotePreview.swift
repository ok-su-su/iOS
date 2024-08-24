//
//  VotePreview.swift
//  SSVotePreview
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SSPersistancy
import SwiftUI
import Vote

// MARK: - ToastPreviewMain

@main
struct ToastPreviewMain: App {
  init() {
    Font.registerFont()
    FakeTokenManager.saveFakeToken(fakeToken: .uid5)
  }

  var body: some Scene {
    WindowGroup {
      VoteBuilder()
    }
  }
}

// MARK: - UINavigationController + ObservableObject, UIGestureRecognizerDelegate

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.isHidden = true
    interactivePopGestureRecognizer?.delegate = self
  }

  public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
