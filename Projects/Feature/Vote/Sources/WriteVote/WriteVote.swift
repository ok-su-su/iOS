//
//  WriteVote.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

// MARK: - WriteVote

@Reducer
struct WriteVote {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "새 투표 작성", type: .depth2Text("등록")))
    var helper: WriteVoteProperty = .init()
    var selectableItems: IdentifiedArrayOf<TextFieldButtonWithTCA<TextFieldButtonWithTCAProperty>.State>
    init() {
      selectableItems = .init(uniqueElements: [])
      setSelectableItemsState()
    }

    mutating func setSelectableItemsState() {
      helper.selectableItem.forEach { property in
        guard let sharedProperty = helper.$selectableItem[id: property.id] else {
          return
        }
        selectableItems.append(.init(sharedItem: sharedProperty))
      }
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedSection(VoteSectionHeaderItem)
    case editedVoteTextContent(String)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case selectableItems(IdentifiedActionOf<TextFieldButtonWithTCA<TextFieldButtonWithTCAProperty>>)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case .scope(.header):
        return .none

      case let .view(.tappedSection(item)):
        state.helper.selectedSection = item
        return .none

      case let .view(.editedVoteTextContent(text)):
        state.helper.voteTextContent = text
        return .none

      case .scope(.selectableItems(.element(id: _, action: _))):
        return .none
      }
    }
    .addFeatures0()
  }
}

extension Reducer where State == WriteVote.State, Action == WriteVote.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    forEach(\.selectableItems, action: \.scope.selectableItems) {
      TextFieldButtonWithTCA()
    }
  }
}
