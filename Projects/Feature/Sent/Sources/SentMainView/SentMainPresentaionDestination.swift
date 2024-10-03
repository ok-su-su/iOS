//
//  SentMainPresentaionDestination.swift
//  Sent
//
//  Created by MaraMincho on 8/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSBottomSelectSheet
import SSSearch

@Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
@CasePathable
enum SentMainPresentationDestination {
  case filter(SentEnvelopeFilter)
  case searchEnvelope(SentSearch)
  case specificEnvelope(SpecificEnvelopeHistoryRouter)
  case filterBottomSheet(SSSelectableBottomSheetReducer<FilterDialItem>)
}
