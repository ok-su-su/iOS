//
//  ReceivedMainPresentationDestination.swift
//  Received
//
//  Created by MaraMincho on 8/31/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSBottomSelectSheet

@Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
enum ReceivedMainPresentationDestination {
  case search(ReceivedSearch)
  case sort(SSSelectableBottomSheetReducer<SortDialItem>)
  case filter(ReceivedFilter)
  case detail(LedgerDetailRouter)
  case createLedger(CreateLedgerRouter)
}
