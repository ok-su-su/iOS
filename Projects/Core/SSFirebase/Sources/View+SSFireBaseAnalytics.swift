//
//  View+SSFireBaseAnalytics.swift
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
  _ viewType: MarketingModulesMain,
  eventName: String = "",
  eventType: SSLogEventType = .none,
  extraParameters: [String: Any] = [:]
) {
  let eventName = eventName + eventType.description
  Analytics.logEvent(viewType.eventLogName(eventName), parameters: extraParameters)
}

public func ssLogEvent(eventName: String, extraParameters: [String: Any] = [:]) {
  Analytics.logEvent(eventName, parameters: extraParameters)
}

@Sendable public func ssLogEvent(_ content: FireBaseSelectContentable) {
  Analytics.logEvent(content.eventName, parameters: content.eventParameters)
}

public func ssErrorLogEvent(
  eventName: String = "ErrorEvent",
  parameters: [String: Any]
) {
  Analytics.logEvent(eventName, parameters: parameters)
}
