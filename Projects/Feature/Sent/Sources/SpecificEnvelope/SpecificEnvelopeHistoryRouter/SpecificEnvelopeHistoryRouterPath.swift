//
//  SpecificEnvelopeHistoryRouterPath.swift
//  Sent
//
//  Created by MaraMincho on 8/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSEnvelope

// MARK: - SpecificEnvelopeHistoryRouterPath

@CasePathable
@Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
enum SpecificEnvelopeHistoryRouterPath {
  case specificEnvelopeHistoryList(SpecificEnvelopeHistoryList)
  case specificEnvelopeHistoryDetail(SpecificEnvelopeDetailReducer)
  case specificEnvelopeHistoryEdit(SpecificEnvelopeEditReducer)
}
