//
//  InventoryFloatingButton.swift
//  SSRoot
//
//  Created by Kim dohyun on 5/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Designsystem

struct InventoryFloatingButton: View {
  @Bindable var floatingStore: StoreOf<InventoryFloating>

  private func makeContentView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      SSImage.commonAdd
        .onTapGesture {
          floatingStore.send(.didTapFloatingButton)
        }
    }
    .padding(12)
    .frame(width: 48, height: 48, alignment: .center)
    .background(SSColor.gray100)
    .cornerRadius(100)
    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 8)
  }

  var body: some View {
    makeContentView()
  }
}
