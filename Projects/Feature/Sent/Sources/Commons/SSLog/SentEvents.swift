//
//  SentEvents.swift
//  Sent
//
//  Created by MaraMincho on 11/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSFirebase

enum SentEvents: FireBaseSelectContentable {
  var eventParameters: [String: Any] {
    switch self {
    case .tappedCreateEnvelope:
      ["tab_name": "보내요"]
    }
  }

  var eventName: String {
    switch self {
    case .tappedCreateEnvelope:
      "send_envelope_creation_start"
    }
  }

  case tappedCreateEnvelope
}
