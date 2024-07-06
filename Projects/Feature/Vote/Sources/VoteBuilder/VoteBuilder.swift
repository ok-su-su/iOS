//
//  VoteBuilder.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct VoteBuilder: View {
  @State var store: StoreOf<VoteMain> = .init(initialState: .init()) {
    VoteMain()
  }

  public var body: some View {
    VoteMainView(store: store)
  }

  public init() {}
}
