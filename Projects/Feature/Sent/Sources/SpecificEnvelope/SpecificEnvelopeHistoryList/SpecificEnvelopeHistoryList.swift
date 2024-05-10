//
//  SpecificEnvelopeHistoryList.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct SpecificEnvelopeHistoryList {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var envelopePriceProgress: EnvelopePriceProgress.State = .init(envelopePriceProgressProperty: .makeFakeData())
    /// Some Logic
    var header: HeaderViewFeature.State = .init(.init(title: "김철수", type: .depth2Text("삭제")))
    @Shared var envelopeHistoryHelper: SpecificEnvelopeHistoryListProperty

    init(envelopeHistoryHelper: Shared<SpecificEnvelopeHistoryListProperty>) {
      self._envelopeHistoryHelper = envelopeHistoryHelper
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedEnvelope(UUID)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case .scope(.header(.tappedTextButton)):
        return .none

      case .scope(.header):
        return .none
      case let .view(.tappedEnvelope(id)):
        return .none
      }
    }
  }
}

// extension Reducer where State == SpecificEnvelopeHistoryList.State, Action == SpecificEnvelopeHistoryList.Action {
//  func subFeatures0() -> some ReducerOf<Self> {
//    ifLet(<#T##WritableKeyPath<State, PresentationState<ChildState>>#>, action: <#T##CaseKeyPath<Action, PresentationAction<ChildAction>>#>)
//  }
// }
