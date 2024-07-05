//
//  SpecificEnvelopeDetailReducer.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation

// MARK: - SpecificEnvelopeDetailReducer

@Reducer
public struct SpecificEnvelopeDetailReducer {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var isDeleteAlertPresent = false
    var header: HeaderViewFeature.State = .init(.init(type: .depth2DoubleText("편집", "삭제")))
    var envelopeDetailProperty: EnvelopeDetailProperty
    var envelopeID: Int64
    public init(envelopeID: Int64) {
      self.envelopeID = envelopeID
      envelopeDetailProperty = .init(id: envelopeID, price: 0, eventName: "", name: "", relation: "", date: .now, isVisited: nil)
//      self.envelopeDetailProperty = .default
    }
  }

  public enum Action: Equatable, FeatureAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  public enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedAlertConfirmButton
  }

  public func viewAction(_ state: inout State, _ action: ViewAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      state.isOnAppear = isAppear
      return .none

    // 삭제 버튼 눌렀을 경우
    case .tappedAlertConfirmButton:
      return .send(.async(.deleteEnvelope))
    }
  }

  public enum InnerAction: Equatable {
    case delete
  }

  public func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .delete:
      state.isDeleteAlertPresent = true
      return .none
    }
  }

  public enum AsyncAction: Equatable {
    case pushEditing
    case deleteEnvelope
  }

  public func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .deleteEnvelope:
      return .run { [id = state.envelopeDetailProperty.id] send in
        try await network.deleteEnvelope(id: id)
        await send(.delegate(.tappedDeleteConfirmButton(id: id)))
        await dismiss()
      }
    case .pushEditing:
      let property = state.envelopeDetailProperty
      return .send(.delegate(.tappedEnvelopeEditButton(property)))
    }
  }

  @CasePathable
  public enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  public func scopeAction(_ state: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .header(.tappedDoubleTextButton(buttonPosition)):
      switch buttonPosition {
      case .leading:
        return .send(.async(.pushEditing))
      case .trailing:
        state.isDeleteAlertPresent = true
        return .send(.inner(.delete))
      }

    case .header:
      return .none
    }
  }

  public enum DelegateAction: Equatable {
    case tappedEnvelopeEditButton(EnvelopeDetailProperty)
    case tappedDeleteConfirmButton(id: Int64)
  }

  public func delegateAction(_: inout State, _: DelegateAction) -> ComposableArchitecture.Effect<Action> {
    return .none
  }

  @Dependency(\.envelopeNetwork) var network
  @Dependency(\.dismiss) var dismiss
  public var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .delegate(currentAction):
        return delegateAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)

      case .binding:
        return .none
      }
    }
  }
}

// MARK: FeatureViewAction, FeatureInnerAction, FeatureDelegateAction, FeatureScopeAction, FeatureAsyncAction

extension SpecificEnvelopeDetailReducer: FeatureViewAction, FeatureInnerAction, FeatureDelegateAction, FeatureScopeAction, FeatureAsyncAction {}
