//
//  InventoryBuilderView.swift
//  Inventory
//
//  Created by Kim dohyun on 5/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

public struct InventoryBuilderView: View {
  public init() {}

  public var body: some View {
    InventoryRouterView(store: .init(initialState: InventoryRouter.State(), reducer: {
      InventoryRouter()
    }))
  }
}
