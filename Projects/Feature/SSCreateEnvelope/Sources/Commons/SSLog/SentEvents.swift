//
//  SentEvents.swift
//  SSCreateEnvelope
//
//  Created by MaraMincho on 11/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSFirebase

// MARK: - SentEvents

public enum SentEvents: FireBaseSelectContentable {
  case tappedCreateEnvelope
  case tappedNextButtonAtCreateEnvelope(type: CreateEnvelopeViewTypes)
  case tappedBackButtonAtCreateEnvelope(type: CreateEnvelopeViewTypes)
  case finishCreateEnvelope

  public var eventParameters: [String: Any] {
    switch self {
    case let .tappedNextButtonAtCreateEnvelope(type):
      ["field_name": type.description]
    case let .tappedBackButtonAtCreateEnvelope(type):
      ["field_name": type.description]
    default:
      [:]
    }
  }

  public var eventName: String {
    switch self {
    case .tappedCreateEnvelope:
      "send_envelope_creation_start"
    case .tappedNextButtonAtCreateEnvelope:
      "send_envelope_next"
    case .tappedBackButtonAtCreateEnvelope:
      "send_envelope_back"
    case .finishCreateEnvelope:
      "send_envelope_creation_complete"
    }
  }
}
