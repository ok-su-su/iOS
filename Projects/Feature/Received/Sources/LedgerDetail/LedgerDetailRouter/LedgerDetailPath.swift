//
//  LedgerDetailPath.swift
//  Received
//
//  Created by MaraMincho on 6/30/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer(state: .equatable, action: .equatable)
enum LedgerDetailPath {
  case main(LedgerDetailMain)
}
