//
//  SSSelectableBottomSheetModifierByScreenRatio.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 8/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - SSSelectableBottomSheetModifierByScreenRatio

public struct SSSelectableBottomSheetModifierByScreenRatio<Item: SSSelectBottomSheetPropertyItemable>: ViewModifier {
  @State var sheetHeight: CGFloat = 0
  var screenRatio: Double
  var bottomView: (() -> any View)?
  public init(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<Item>>?>,
    screenRatio: Double = 0.5,
    bottomView: (() -> any View)? = nil
  ) {
    _store = store
    self.bottomView = bottomView
    self.screenRatio = screenRatio
  }

  @Binding var store: StoreOf<SSSelectableBottomSheetReducer<Item>>?

  public func body(content: Content) -> some View {
    content
      .getSize { size in
        sheetHeight = size.height * screenRatio
      }
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
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<some SSSelectBottomSheetPropertyItemable>>?>,
    screenRatio: Double = 0.5
  ) -> some View {
    modifier(SSSelectableBottomSheetModifierByScreenRatio(store: store, screenRatio: screenRatio))
  }

  func selectableBottomSheetWithBottomView(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<some SSSelectBottomSheetPropertyItemable>>?>,
    screenRatio: Double = 0.5,
    @ViewBuilder content: @escaping () -> some View
  ) -> some View {
    modifier(SSSelectableBottomSheetModifierByScreenRatio(store: store, screenRatio: screenRatio, bottomView: content))
  }
}
