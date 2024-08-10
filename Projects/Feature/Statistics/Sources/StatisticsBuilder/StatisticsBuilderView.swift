//
//  StatisticsBuilderView.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct StatisticsBuilderView: View {
  private var store: StoreOf<StatisticsMain> = .init(initialState: .init()) {
    StatisticsMain()
  }

  public init() {}
  public var body: some View {
    StatisticsMainView(store: store)
  }
}
