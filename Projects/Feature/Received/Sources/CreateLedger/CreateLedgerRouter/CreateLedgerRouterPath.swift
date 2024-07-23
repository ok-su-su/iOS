//
//  CreateLedgerRouterPath.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer(state: .equatable, action: .equatable)
enum CreateLedgerRouterPath {
  case category(CreateLedgerCategory)
  case name(CreateLedgerName)
  case date(CreateLedgerDate)
}
