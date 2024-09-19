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
  case Onboarding(OnboardingMarketingModule)
  case Sent(SentMarketingModule)
  case Received(ReceivedMarketingModule)
  case Statistics(StatisticsMarketingModule)
  case Vote(VoteMarketingModule)
  case MyPage(MyPageMarketingModule)

  public var description: String {
    switch self {
    case let .Onboarding(view):
      Self.descriptionMaker(moduleName: moduleName, viewName: view.description)
    case let .Sent(view):
      Self.descriptionMaker(moduleName: moduleName, viewName: view.description)
    case let .Received(view):
      Self.descriptionMaker(moduleName: moduleName, viewName: view.description)
    case let .Statistics(view):
      Self.descriptionMaker(moduleName: moduleName, viewName: view.description)
    case let .Vote(view):
      Self.descriptionMaker(moduleName: moduleName, viewName: view.description)
    case let .MyPage(view):
      Self.descriptionMaker(moduleName: moduleName, viewName: view.description)
    }
  }

  var moduleName: String {
    switch self {
    case .Onboarding:
      "온보딩"
    case .Sent:
      "보내요"
    case .Received:
      "받아요"
    case .Statistics:
      "통계"
    case .Vote:
      "투표"
    case .MyPage:
      "마이페이지"
    }
  }

  private static func descriptionMaker(moduleName: String, viewName: String) -> String {
    let loggerIdentifier = "iOS Application"
    let viewName = viewName + "화면"
    let forJoinString = " / "
    return [loggerIdentifier, moduleName, viewName].joined(separator: forJoinString)
  }
}
