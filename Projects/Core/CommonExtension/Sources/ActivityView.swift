//
//  ActivityView.swift
//  CommonExtension
//
//  Created by MaraMincho on 9/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

/// UIActivityViewController 를 swiftUI로 래핑했습니다.
public struct ActivityView: UIViewControllerRepresentable {
  let activityItems: [Any]
  let applicationActivities: [UIActivity]?

  public init(activityItems: [Any], applicationActivities: [UIActivity]?) {
    self.activityItems = activityItems
    self.applicationActivities = applicationActivities
  }

  public func makeUIViewController(context _: Context) -> UIActivityViewController {
    return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
  }

  public func updateUIViewController(_: UIActivityViewController, context _: Context) {}
}
