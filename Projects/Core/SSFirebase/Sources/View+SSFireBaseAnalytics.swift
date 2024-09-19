//
//  SSFireBase.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import FirebaseAnalytics
import SwiftUI

public extension View {
  func ssAnalyticsScreen(
    moduleName name: MarketingModulesMain,
    class: String = "View",
    extraParameters: [String: Any] = [:]
  ) -> some View {
    analyticsScreen(name: name.description, class: `class`, extraParameters: extraParameters)
  }
}

public func ssLogEvent(
  _ moduleName: MarketingModulesMain,
  eventName: String,
  eventType: SSLogEventType = .none,
  extraParameters: [String: Any] = [:]
) {
  let eventName = eventName + eventType.description
  Analytics.logEvent(eventName.description, parameters: extraParameters)
}

public enum SSLogEventType: Equatable, CustomStringConvertible {
  case onAppear
  case tapped
  case none

  public var description: String {
    switch self {
    case .onAppear:
      "접근"
    case .tapped:
      "터치"
    case .none:
      ""
    }
  }
}
