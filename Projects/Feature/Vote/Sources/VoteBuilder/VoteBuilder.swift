//
//  VoteBuilder.swift
//  Vote
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct VoteBuilder: View {
    public var body: some View {
      VoteMainView(store:
          .init( initialState: .init(), reducer: { VoteMain() } )
      )
    }
}
