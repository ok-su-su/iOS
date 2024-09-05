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
    moduleName name: MarketingModules,
    class: String = "View",
    extraParameters: [String: Any] = [:]
  ) -> some View {
    analyticsScreen(name: name.description, class: `class`, extraParameters: extraParameters)
  }
}

// MARK: - MarketingModules

public enum MarketingModules: CustomStringConvertible, Equatable {
  case Sent(SentMarketingModule)
  case Received(ReceivedMarketingModule)
  case Statistics(StatisticsMarketingModule)
  case Vote(VoteMarketingModule)
  case MyPage(MyPageMarketingModule)

  public var description: String {
    switch self {
    case let .Sent(subModule):
      "보내요 / \(subModule.description) 화면"
    case let .Received(subModule):
      "받아요 / \(subModule.description) 화면"
    case let .Statistics(subModule):
      "통계 / \(subModule.description) 화면"
    case let .Vote(subModule):
      "투표 / \(subModule.description) 화면"
    case let .MyPage(subModule):
      "투표 / \(subModule.description) 화면"
    }
  }
}
