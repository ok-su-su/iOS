//
//  SpecificEnvelopeHistoryDetail.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation

@Reducer
struct SpecificEnvelopeHistoryDetail {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isDeleteAlertPresent = false
    var header: HeaderViewFeature.State = .init(.init(type: .depth2DoubleText("편집", "삭제")))
    var envelopeDetailProperty: EnvelopeDetailProperty
    init(envelopeDetailProperty: EnvelopeDetailProperty) {
      self.envelopeDetailProperty = envelopeDetailProperty
    }
  }

  enum Action: Equatable, FeatureAction, BindableAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedAlertConfirmButton
  }

  enum InnerAction: Equatable {
    case editing
    case delete
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case let .scope(.header(.tappedDoubleTextButton(buttonPosition))):
        switch buttonPosition {
        case .leading:
          return .send(.inner(.editing))
        case .trailing:
          state.isDeleteAlertPresent = true
          return .send(.inner(.delete))
        }

      case .scope(.header):
        return .none

      // TODO: Navigate EditingScene
      case .inner(.editing):
        return .none

      case .inner(.delete):
        state.isDeleteAlertPresent = true
        return .none
      case .binding:
        return .none

      // TODO: 들리트 버튼을 눌렀을 때 로직 실행
      case .view(.tappedAlertConfirmButton):
        return .none
      }
    }
  }
}
