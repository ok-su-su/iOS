//
//  VoteRouterView.swift
//  Vote
//
//  Created by MaraMincho on 5/24/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import SwiftUI

struct VoteRouterView: View {
  // MARK: Reducer

  @Bindable
  var store: StoreOf<VoteRouter>

  // MARK: Content

  @ViewBuilder
  private func makeContentView() -> some View {}

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Color.clear
        .onAppear {
          store.send(.onAppear(true))
        }
    } destination: { store in
      switch store.case {
      case let .write(store):
        WriteVoteView(store: store)

      case let .otherVoteDetail(store):
        OtherVoteDetailView(store: store)

      case let .search(store):
        VoteSearchView(store: store)

      case let .myVote(store):
        MyVoteDetailView(store: store)

      case let .edit(store):
        EditMyVoteView(store: store)
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
