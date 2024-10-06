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
import SSNetwork
import SSNotification

// MARK: - SpecificEnvelopeDetailReducer

@Reducer
public struct SpecificEnvelopeDetailReducer: Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false
    var isDeleteAlertPresent = false
    var isLoading = false
    var header: HeaderViewFeature.State = .init(.init(type: .depth2DoubleText("편집", "삭제")))
    var envelopeDetailProperty: EnvelopeDetailProperty?
    var envelopeID: Int64
    var isUpdateEnvelope: Bool = false
    let isShowCategory: Bool
    public init(envelopeID: Int64, isShowCategory: Bool = true) {
      self.envelopeID = envelopeID
      self.isShowCategory = isShowCategory
      envelopeDetailProperty = nil
    }
  }

  public enum Action: Equatable, FeatureAction, BindableAction, Sendable {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedAlertConfirmButton
  }

  public func viewAction(_ state: inout State, _ action: ViewAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .onAppear(isAppear):

      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .merge(
        .publisher {
          UpdateEnvelopeDetailPropertyPublisher
            .publisher()
            .receive(on: RunLoop.main)
            .map { .inner(.updateEnvelopeDetailProperty($0)) }
        },

        .send(.async(.getEnvelopeDetailProperty))
      )

    // 삭제 버튼 눌렀을 경우
    case .tappedAlertConfirmButton:
      return .send(.async(.deleteEnvelope))
    }
  }

  public enum InnerAction: Equatable, Sendable {
    case delete
    case updateEnvelopeDetailProperty(EnvelopeDetailProperty)
    case isLoading(Bool)
  }

  public func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .delete:
      state.isDeleteAlertPresent = true
      return .none

    case let .updateEnvelopeDetailProperty(property):
      state.isUpdateEnvelope = true
      state.envelopeDetailProperty = property
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none
    }
  }

  public enum AsyncAction: Equatable, Sendable {
    case pushEditing
    case deleteEnvelope
    case getEnvelopeDetailProperty
  }

  @Dependency(\.specificEnvelopePublisher) var specificEnvelopePublisher
  public func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .deleteEnvelope:

      return .ssRun { [id = state.envelopeID, network, specificEnvelopePublisher, dismiss] _ in
        try await network.deleteEnvelope(id)
        specificEnvelopePublisher.sendDeleteEnvelopeBy(ID: id)
        await dismiss()
      }
    case .pushEditing:
      let property = state.envelopeDetailProperty
      return .ssRun { send in
        guard let property else {
          let errorMessage = "envelopeDetailProperty가 생성되지 않은 상태에서 edit화면으로 이동하려고 합니다."
          throw SUSUError(error: NSError(), response: nil)
        }
        await send(.delegate(.tappedEnvelopeEditButton(property)))
      }

    case .getEnvelopeDetailProperty:
      return .ssRun { [id = state.envelopeID, network] send in
        await send(.inner(.isLoading(true)))
        let property = try await network.getEnvelopeDetailPropertyByEnvelopeID(id)
        await send(.inner(.updateEnvelopeDetailProperty(property)))
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  public enum ScopeAction: Equatable, Sendable {
    case header(HeaderViewFeature.Action)
  }

  public func scopeAction(_ state: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .header(.tappedDismissButton):
      if state.isUpdateEnvelope {
        specificEnvelopePublisher.sendUpdateEnvelopeBy(ID: state.envelopeID)
      }
      return .none
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

  public enum DelegateAction: Equatable, Sendable {
    case tappedEnvelopeEditButton(EnvelopeDetailProperty)
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

  public init() {}
}

// MARK: FeatureViewAction, FeatureInnerAction, FeatureDelegateAction, FeatureScopeAction, FeatureAsyncAction

extension SpecificEnvelopeDetailReducer: FeatureViewAction, FeatureInnerAction, FeatureDelegateAction, FeatureScopeAction, FeatureAsyncAction {}
