//
//  LedgerDetailMainPresentationDestination.swift
//  Received
//
//  Created by MaraMincho on 8/31/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation
import SSBottomSelectSheet

@Reducer(state: .equatable, action: .equatable)
enum LedgerDetailMainPresentationDestination {
  case filter(LedgerDetailFilter)
  case sort(SSSelectableBottomSheetReducer<SortDialItemForLedgerEnvelopeItem>)
}
