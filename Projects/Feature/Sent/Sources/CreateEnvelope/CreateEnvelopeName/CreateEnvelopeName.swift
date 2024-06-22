//
//  CreateEnvelopeName.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog

@Reducer
struct CreateEnvelopeName {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var textFieldText: String = ""
    var isFocused = false
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var networkHelper = CreateEnvelopeNetwork()

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    var filteredPrevEnvelopes: [PrevEnvelope] {
      return textFieldText == "" ? createEnvelopeProperty.prevEnvelopes : createEnvelopeProperty.filteredName(textFieldText)
    }

    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
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
    case tappedFilterItem(name: String)
    case changeText(String)
    case changeFocused(Bool)
  }

  enum InnerAction: Equatable {
    case push
    case updateEnvelopes([PrevEnvelope])
    case searchName(String)
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case nextButton(CreateEnvelopeBottomOfNextButton.Action)
  }

  enum DelegateAction: Equatable {}

  enum ThrottleID {
    case search
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.nextButton, action: \.scope.nextButton) {
      CreateEnvelopeBottomOfNextButton()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        state.isFocused = true
        return .run { [helper = state.networkHelper] send in
          let prevEnvelopes = try await helper.searchInitialEnvelope()
          await send(.inner(.updateEnvelopes(prevEnvelopes)))
        }

      case .inner(.push):
        CreateFriendRequestShared.setName(state.textFieldText)
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeRelation(.init(state.$createEnvelopeProperty)))
        return .none

      case let .view(.tappedFilterItem(name: name)):
        state.textFieldText = name
        return .none

      case .scope(.nextButton(.view(.tappedNextButton))):
        return .run { send in
          await send(.inner(.push))
        }

      case .scope(.nextButton):
        return .none

      case let .view(.changeText(text)):
        state.textFieldText = text
        /// 만약 이름 검색 조건을 만족한다면
        if NameRegexManager.isValid(name: text) {
          return .run { send in
            await send(.inner(.searchName(text)))
            await send(.scope(.nextButton(.delegate(.isAbleToPush(true)))))
          }
          .throttle(id: ThrottleID.search, for: 0.5, scheduler: mainQueue, latest: true)
        }
        
        /// 만약 이름 검색 조건을 만족하지 않는다면
        return .send(.scope(.nextButton(.delegate(.isAbleToPush(false)))))

      case let .view(.changeFocused(val)):
        state.isFocused = val
        return .none

      case let .inner(.updateEnvelopes(prevEnvelopes)):
        let target = state.createEnvelopeProperty.prevEnvelopes + prevEnvelopes
        state.createEnvelopeProperty.prevEnvelopes = target.uniqued()
        return .none

      case let .inner(.searchName(val)):
        return .run { [helper = state.networkHelper] send in
          let prevEnvelopes = try await helper.searchPrevName(val)
          await send(.inner(.updateEnvelopes(prevEnvelopes)))
        }
      }
    }
  }
}
