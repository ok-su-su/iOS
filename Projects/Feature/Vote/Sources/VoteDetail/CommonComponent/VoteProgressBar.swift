//
//  VoteProgressBar.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

// MARK: - VoteProgressBarReducer

@Reducer
struct VoteProgressBarReducer {
  @ObservableState
  struct State: Equatable, Identifiable {
    @Shared var property: VoteProgressBarProperty
    var id: Int {
      return property.id
    }

    init(property: Shared<VoteProgressBarProperty>) {
      _property = property
    }
  }

  enum Action: Equatable {
    case tapped
  }

  var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .tapped:
        return .none
      }
    }
  }
}

// MARK: - VoteProgressBar

struct VoteProgressBar: View {
  @Bindable
  var store: StoreOf<VoteProgressBarReducer>
  var body: some View {
    let progress = store.property.showVoteProgressBarProperty
    ZStack(alignment: .leading) {
      // progress bar
      if let progress {
        GeometryReader { proxy in
          SSColor.orange40
            .frame(width: proxy.size.width * progress.progressPercentage, alignment: .leading)
        }
      }

      HStack(alignment: .center, spacing: 0) {
        // if voted, add check image
        if let progress, progress.isVoted {
          SSImage
            .commonCheckBox
            .resizable()
            .frame(width: 20, height: 20)
        }

        Text(store.property.title)
          .modifier(SSTypoModifier(.title_xxs))
          .foregroundStyle(SSColor.gray100)

        Spacer()

        // if show Progress
        if let progress {
          HStack(spacing: 8) {
            Text(progress.participantCountText)
              .modifier(SSTypoModifier(.text_xxxs))
              .foregroundStyle(SSColor.gray70)

            Text(progress.progressText)
              .modifier(SSTypoModifier(.title_xxs))
              .foregroundStyle(SSColor.gray100)
          }
        }
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
    }
    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
    .background(SSColor.orange10)
    .clipShape(RoundedRectangle(cornerRadius: 4))
    .onTapGesture {
      store.send(.tapped)
    }
  }
}

// MARK: - VoteProgressBarProperty

struct VoteProgressBarProperty: Equatable, Identifiable {
  var id: Int
  var title: String
  var showVoteProgressBarProperty: ShowVoteProgressBarProperty?
  struct ShowVoteProgressBarProperty: Equatable {
    var progress: Int
    var showProgress: Bool
    var participantsCount: Int
    var isVoted: Bool

    var participantCountText: String {
      return "\(participantsCount)명"
    }

    var progressText: String {
      return "\(progress.description)%"
    }

    var progressPercentage: Double {
      return Double(progress) / 100
    }
  }

  init(id: Int, title: String, showVoteProgressBarProperty: ShowVoteProgressBarProperty? = nil) {
    self.id = id
    self.title = title
    self.showVoteProgressBarProperty = showVoteProgressBarProperty
  }
}
