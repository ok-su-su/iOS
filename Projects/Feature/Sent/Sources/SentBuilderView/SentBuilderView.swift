//
//  SentBuilderView.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SentBuilderView: View {
  public init() {}
  @State private var store: StoreOf<SentMain> = .init(initialState: .init()) {
    SentMain()
  }

  public var body: some View {
    SentMainView(store: store)
  }
}
