//
//  ReceivedBuilderView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct ReceivedBuilderView: View {
  public init() {}

  @State private var store: StoreOf<ReceivedMain> = .init(initialState: .init()) {
    ReceivedMain()
  }

  public var body: some View {
    ReceivedMainView(store: store)
  }
}
