//
//  StatisticsBuilderView.swift
//  Statistics
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

public struct StatisticsBuilderView: View {
  public init() {}
  public var body: some View {
    StatisticsMainView(store: .init(initialState: StatisticsMain.State(), reducer: {
      StatisticsMain()
    }))
  }
}
