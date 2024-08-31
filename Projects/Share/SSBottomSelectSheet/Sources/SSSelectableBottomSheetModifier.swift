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
  @State var sheetHeight: CGFloat = 0
  var cellCount: Int
  var bottomView: (() -> any View)?
  var availableFullScreenMode: Bool
  public init(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<Item>>?>,
    cellCount: Int = 0,
    availableFullScreenMode: Bool,
    bottomView: (() -> any View)? = nil
  ) {
    _store = store
    self.bottomView = bottomView
    self.cellCount = cellCount
    self.availableFullScreenMode = availableFullScreenMode
  }

  @Binding var store: StoreOf<SSSelectableBottomSheetReducer<Item>>?

  public func body(content: Content) -> some View {
    content
      .sheet(item: $store) { store in
        SSSelectableBottomSheetView<Item>(store: store)
          .presentationDetents(presentationDetents)
          .presentationContentInteraction(.scrolls)
          .presentationDragIndicator(.hidden)
          .safeAreaInset(edge: .bottom) {
            if let bottomView {
              AnyView(bottomView())
            }
          }
          .task {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScene?.windows.first

            let handleHeight: CGFloat = 40
            let bottom = window?.safeAreaInsets.bottom ?? 0
            let cellHeight = CGFloat(cellCount) * 48

            sheetHeight = handleHeight + bottom + cellHeight
          }
      }
  }

  var presentationDetents: Set<PresentationDetent> {
    let defaultHeight: PresentationDetent = .height(sheetHeight)
    return availableFullScreenMode ? [defaultHeight, PresentationDetent.large] : [defaultHeight]
  }
}

public extension View {
  func selectableBottomSheet(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<some SSSelectBottomSheetPropertyItemable>>?>,
    cellCount: Int = 4,
    availableFullScreenMode: Bool = false
  ) -> some View {
    modifier(
      SSSelectableBottomSheetModifier(
        store: store,
        cellCount: cellCount,
        availableFullScreenMode: availableFullScreenMode
      )
    )
  }

  func selectableBottomSheetWithBottomView(
    store: Binding<StoreOf<SSSelectableBottomSheetReducer<some SSSelectBottomSheetPropertyItemable>>?>,
    cellCount: Int = 4,
    availableFullScreenMode: Bool = false,
    @ViewBuilder content: @escaping () -> some View
  ) -> some View {
    modifier(
      SSSelectableBottomSheetModifier(
        store: store,
        cellCount: cellCount,
        availableFullScreenMode: availableFullScreenMode,
        bottomView: content
      )
    )
  }
}
