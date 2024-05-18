//
//  SSToastView.swift
//  SSToast
//
//  Created by MaraMincho on 5/18/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

public struct SSToastView: View {
  // MARK: Reducer

  @Bindable
  public var store: StoreOf<SSToastReducer>

  // MARK: Content

  @ViewBuilder
  private func makeTrailingItem() -> some View {
    switch store.sSToastProperty.type {
    case .none:
      EmptyView()

    case let .text(buttonTitle):
      Text(buttonTitle)
        .modifier(SSTypoModifier(.title_xxs))
        .foregroundStyle(SSColor.blue40)

    case .refresh:
      SSImage
        .commonRefresh
    }
  }

  @ViewBuilder
  private func makeTextItem() -> some View {
    Text(store.state.toastMessage)
      .modifier(SSTypoModifier(.text_xxs))
      .foregroundStyle(SSColor.gray10)
  }

  public var body: some View {
    VStack {
      if store.isOnAppear == false {
        EmptyView()
      } else {
        HStack(alignment: .center, spacing: 16) {
          makeTextItem()
          makeTrailingItem()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.96))
        .cornerRadius(4)
      }
    }
    .onAppear {
      store.send(.onAppear(true))
    }
  }

  // MARK: Init

  public init(store: StoreOf<SSToastReducer>) {
    self.store = store
  }

  private enum Metrics {}

  private enum Constants {}
}
