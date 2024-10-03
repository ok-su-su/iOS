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
public struct CreateEnvelopeName: Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false
    var textFieldText: String = ""
    var nextButton = CreateEnvelopeBottomOfNextButton.State()
    var isPushable = false
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var createType = CreateEnvelopeRequestShared.getCreateType()

    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    var filteredPrevEnvelopes: [SearchFriendItem] {
      return textFieldText == "" ? createEnvelopeProperty.prevEnvelopes : createEnvelopeProperty.filteredName(textFieldText)
    }

    public init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
    }
  }

  public enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedFilterItem(name: String)
    case changeText(String)
    case tappedNextButton
  }

  private func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
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
      let isEmptyTextField = text.isEmpty
      return .merge(
        isShowToast ?
          .send(.scope(.toast(.showToastMessage(DefaultToastMessage.name.message)))) : .none,
        isEmptyTextField ?
          .send(.inner(.emptyTextField)) : .send(.async(.searchName(text)))
      )

    case .tappedNextButton:
      return .send(.inner(.push))
    }
  }

  public enum InnerAction: Equatable, Sendable {
    case push
    case updateEnvelopes([SearchFriendItem])
    case emptyTextField
  }

  private func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .push:
      CreateFriendRequestShared.setName(state.textFieldText)
      CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeRelation(.init(state.$createEnvelopeProperty)))
      return .none

    case let .updateEnvelopes(prevEnvelopes):
      let target = state.createEnvelopeProperty.prevEnvelopes + prevEnvelopes
      state.createEnvelopeProperty.prevEnvelopes = target.uniqued()
      return .none

    case .emptyTextField:
      state.createEnvelopeProperty.prevEnvelopes.removeAll()
      return .none
    }
  }

  public enum AsyncAction: Equatable, Sendable {
    case searchName(String)
  }

  private func asyncAction(_: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case let .searchName(val):
      return .ssRun { send in
        let prevEnvelopes = try await network.searchFriendByName(val)
        await send(.inner(.updateEnvelopes(prevEnvelopes)))
      }
    }
  }

  @CasePathable
  public enum ScopeAction: Equatable, Sendable {
    case toast(SSToastReducer.Action)
  }

  private func scopeAction(_: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case .toast:
      return .none
    }
  }

  public enum DelegateAction: Equatable, Sendable {}

  private enum ThrottleID {
    case search
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.createEnvelopeNameNetwork) var network

  public var body: some Reducer<State, Action> {
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

extension CreateEnvelopeName {}
