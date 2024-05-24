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
  private func makeContentView() -> some View {
    switch store.initialPath {
    case .voteDetail:
      OtherVoteDetailView(store: .init(initialState: OtherVoteDetail.State()) {
        OtherVoteDetail()
      })
    case .write:
      WriteVoteView(store: .init(initialState: WriteVote.State()) {
        WriteVote()
      })
    case .search:
      VoteSearchView(store: .init(initialState: VoteSearch.State()) {
        VoteSearch()
      })
    }
  }

  var body: some View {
    VStack {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        makeContentView()
      } destination: { store in
        switch store.case {
        case let .write(store):
          WriteVoteView(store: store)

        case let .otherVoteDetail(store):
          OtherVoteDetailView(store: store)

        case let .search(store):
          VoteSearchView(store: store)
        }
      }
    }
  }

  private enum Metrics {}

  private enum Constants {}
}
