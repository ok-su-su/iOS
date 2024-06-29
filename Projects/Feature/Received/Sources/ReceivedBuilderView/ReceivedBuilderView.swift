//
//  ReceivedBuilderView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

public struct ReceivedBuilderView: View {
  public init() {}
  public var body: some View {
    ReceivedMainView(store: .init(initialState: .init(), reducer: {
      ReceivedMain()
    }))
  }
}
