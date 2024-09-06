//
//  SafariWebView.swift
//  MyPage
//
//  Created by MaraMincho on 9/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SafariServices
import SwiftUI

struct SafariWebView: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context _: Context) -> SFSafariViewController {
    return SFSafariViewController(url: url)
  }

  func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}
