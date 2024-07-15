//
//  SSSelectableBottomSheetModifier.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SSSelectableBottomSheetModifier<Item: SSSelectBottomSheetPropertyItemable>: ViewModifier {
  public init(store: Binding<StoreOf<SSSelectableBottomSheetReducer<Item>>?>) {
    _store = store
  }

  @Binding var store: StoreOf<SSSelectableBottomSheetReducer<Item>>?

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSSelectableBottomSheetView<Item>(store: store)
          .presentationDetents([.height(230), .medium, .large])
          .presentationContentInteraction(.scrolls)
          .presentationDragIndicator(.hidden)
      }
  }
}
