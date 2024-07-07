//
//  SSDateBottomSheetModifier.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 6/22/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - SSDateBottomSheetModifier

public struct SSDateBottomSheetModifier: ViewModifier {
  public init(store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>) {
    _store = store
  }

  @Binding var store: StoreOf<SSDateSelectBottomSheetReducer>?

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSDateSelectBottomSheetView(store: store)
          .presentationDetents([.height(282), .medium, .large])
          .presentationContentInteraction(.scrolls)
          .presentationDragIndicator(.automatic)
      }
  }
}

public extension View {
  func showDatePicker(store: Binding<StoreOf<SSDateSelectBottomSheetReducer>?>) -> some View {
    modifier(SSDateBottomSheetModifier(store: store))
  }
}
