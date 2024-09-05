//
//  ReceivedMarketingModule.swift
//  SSFirebase
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - ReceivedMarketingModule

public enum ReceivedMarketingModule: CustomStringConvertible, Equatable {
  case main
  case createEnvelope(CreateEnvelopeMarketingModule)
  public var description: String {
    switch self {
    case .main:
      "메인"
    case let .createEnvelope(current):
      current.description
    }
  }
}
