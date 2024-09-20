//
//  SSLogEventType.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

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
