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
    case delete
  }

  enum AsyncAction: Equatable {
    case pushEditing
    case deleteEnvelope
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.envelopeNetwork) var network
  @Dependency(\.dismiss) var dismiss
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
          return .send(.async(.pushEditing))
        case .trailing:
          state.isDeleteAlertPresent = true
          return .send(.inner(.delete))
        }

      case .scope(.header):
        return .none

      // TODO: Navigate EditingScene
      case .async(.pushEditing):

        return .run { [id = state.envelopeDetailProperty.id] _ in
          let helper = try await network.getSpecificEnvelopeHistoryEditHelperBy(envelopeID: id)
          SpecificEnvelopeHistoryRouterPublisher
            .push(.specificEnvelopeHistoryEdit(.init(editHelper: helper)))
        }

      case .inner(.delete):
        state.isDeleteAlertPresent = true
        return .none
      case .binding:
        return .none

      // 삭제 버튼 눌렀을 경우
      case .view(.tappedAlertConfirmButton):
        return .send(.async(.deleteEnvelope))

      case .async(.deleteEnvelope):
        return .run { [id = state.envelopeDetailProperty.id] _ in
          try await network.deleteEnvelope(id: id)
          // Shared State 저장
          SpecificEnvelopeSharedState.shared.setDeleteEnvelopeID(id)
          await dismiss()
        }
      }
    }
  }
}
