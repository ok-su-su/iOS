//
//  LedgerDetailPath.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSEnvelope

@Reducer(state: .equatable, action: .equatable)
enum LedgerDetailPath {
  case main(LedgerDetailMain)
  case envelopeDetail(SpecificEnvelopeDetailReducer)
  case envelopeEdit(SpecificEnvelopeEditReducer)
  case edit(LedgerDetailEdit)
}
