//
//  TapBarEvents.swift
//  SSFirebase
//
//  Created by MaraMincho on 11/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum TabBarEvents: FireBaseSelectContentable {
  case Received
  case Sent
  case Statistics
  case MyPage
  case Vote

  public var eventName: String { "tab_view" }
  public var eventParameters: [String: Any] {
    let currentEventName = switch self {
    case .Received:
      "받아요"
    case .Sent:
      "보내요"
    case .Statistics:
      "통계"
    case .MyPage:
      "마이페이지"
    case .Vote:
      "투표"
    }
    return ["tab_name": currentEventName]
  }
}
