//
//  SpecificEnvelopeHistoryEdit.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

@Reducer
struct SpecificEnvelopeHistoryEdit {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(type: .depth2Default))
    var eventSection: TitleAndItemsWithSingleSelectButton<EventSingeSelectButtonItem>.State
    @Shared var editHelper: SpecificEnvelopeHistoryEditHelper

    // TODO: BottomOFCompleteButton(다른 브런치에 있는 것 가져와서 수정)
    init(editHelper: Shared<SpecificEnvelopeHistoryEditHelper>) {
      _editHelper = editHelper

      eventSection = .init(singleSelectButtonHelper: _editHelper.eventSectionButtonHelper)
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
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case eventSection(TitleAndItemsWithSingleSelectButton<EventSingeSelectButtonItem>.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.eventSection, action: \.scope.eventSection) {
      TitleAndItemsWithSingleSelectButton()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .scope(.header):
        return .none

      case .scope(.eventSection):
        return .none
      }
    }
  }
}
