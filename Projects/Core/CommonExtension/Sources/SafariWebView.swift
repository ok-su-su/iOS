//
//  SafariWebView.swift
//  MyPage
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SafariServices
import SwiftUI
import UIKit

public struct SafariWebView: UIViewControllerRepresentable {
  public init(url: URL) {
    self.url = url
  }

  let url: URL

  public func makeUIViewController(context _: Context) -> SFSafariViewController {
    return SFSafariViewController(url: url)
  }

  public func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}
