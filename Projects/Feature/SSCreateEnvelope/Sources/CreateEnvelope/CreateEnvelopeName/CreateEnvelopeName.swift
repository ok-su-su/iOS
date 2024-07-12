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
import SSRegexManager
import SSToast

// MARK: - CreateEnvelopeName

@Reducer
struct CreateEnvelopeName {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var textFieldText: String = ""
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var isPushable = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var createType = CreateEnvelopeRequestShared.getCreateType()

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
    case tappedNextButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .none

    case let .tappedFilterItem(name):
      state.textFieldText = name
      return .none

    case let .changeText(text):
      state.textFieldText = text
      let pushable = RegexManager.isValidName(text)
      state.isPushable = pushable

      let isShowToast = ToastRegexManager.isShowToastByName(text)
      return .merge(
        isShowToast ?
          .send(.scope(.toast(.showToastMessage("이름은 10글자까지만 입력 가능해요")))) : .none,
        .send(.async(.searchName(text)))
      )

    case .tappedNextButton:
      return .send(.inner(.push))
    }
  }

  enum InnerAction: Equatable {
    case push
    case updateEnvelopes([PrevEnvelope])
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .push:
      CreateFriendRequestShared.setName(state.textFieldText)
      CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeRelation(.init(state.$createEnvelopeProperty)))
      return .none

    case let .updateEnvelopes(prevEnvelopes):
      let target = state.createEnvelopeProperty.prevEnvelopes + prevEnvelopes
      state.createEnvelopeProperty.prevEnvelopes = target.uniqued()
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case searchName(String)
  }

  func asyncAction(_: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case let .searchName(val):
      return .run { send in
        let prevEnvelopes = try await network.searchPrevName(val)
        await send(.inner(.updateEnvelopes(prevEnvelopes)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case toast(SSToastReducer.Action)
  }

  func scopeAction(_: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case .toast:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  enum ThrottleID {
    case search
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.createEnvelopeNameNetwork) var network

  var body: some Reducer<State, Action> {
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureInnerAction, FeatureAsyncAction, FeatureScopeAction

extension CreateEnvelopeName: FeatureViewAction, FeatureInnerAction, FeatureAsyncAction, FeatureScopeAction {}
