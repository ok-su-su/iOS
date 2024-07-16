//
//  SSSelectableBottomSheetModifier.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - SSSelectableBottomSheetModifier

public struct SSSelectableBottomSheetModifier<Item: SSSelectBottomSheetPropertyItemable>: ViewModifier {
  var sheetHeight: CGFloat
  var bottomView: (() -> any View)?
  public init(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<Item>>?>,
    sheetHeight: CGFloat = 230,
    bottomView: (() -> any View)? = nil
  ) {
    _store = store
    self.sheetHeight = sheetHeight
    self.bottomView = bottomView
  }

  @Binding var store: StoreOf<SSSelectableBottomSheetReducer<Item>>?

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSSelectableBottomSheetView<Item>(store: store)
          .presentationDetents([.height(sheetHeight), .medium, .large])
          .presentationContentInteraction(.scrolls)
          .presentationDragIndicator(.hidden)
          .safeAreaInset(edge: .bottom) {
            if let bottomView {
              AnyView(bottomView())
            }
          }
      }
  }
}

public extension View {
  func selectableBottomSheet(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<some SSSelectBottomSheetPropertyItemable>>?>
  ) -> some View {
    modifier(SSSelectableBottomSheetModifier(store: store))
  }

  func selectableBottomSheetWithBottomView(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<some SSSelectBottomSheetPropertyItemable>>?>,
    sheetHeight: CGFloat,
    @ViewBuilder content: @escaping () -> some View
  ) -> some View {
    modifier(SSSelectableBottomSheetModifier(store: store, sheetHeight: sheetHeight, bottomView: content))
  }
}
