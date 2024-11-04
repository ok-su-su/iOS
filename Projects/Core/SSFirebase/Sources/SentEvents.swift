//
//  SentEvents.swift
//  SSFirebase
//
//  Created by MaraMincho on 11/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public enum SentEvents: FireBaseSelectContentable {
  case tappedCreateEnvelope
  case tappedNextButtonAtCreateEnvelope
  case tappedBackButtonAtCreateEnvelope
  case finishCreateEnvelope

  public var eventParameters: [String : Any] {[ :] }

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
