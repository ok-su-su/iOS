//
//  CreateEnvelopeSelectItemsView.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct CreateEnvelopeSelectItemsView<Item: CreateEnvelopeSelectItemable>: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<CreateEnvelopeSelectItems<Item>>

  init(store: StoreOf<CreateEnvelopeSelectItems<Item>>) {
    self.store = store
  }

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {}

  var body: some View {
    EmptyView()
    ForEach(store.items) { item in
      SSButton(
        .init(
          size: .mh60,
          status: .active,
          style: store.selectedID.contains(item.id) ? .filled : .ghost,
          color: store.selectedID.contains(item.id) ? .orange : .black,
          buttonText: item.title,
          frame: .init(maxWidth: .infinity)
        )) {
          store.send(.view(.tappedItem(id: item.id)))
        }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
