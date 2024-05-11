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
    var relationSection: TitleAndItemsWithSingleSelectButton<RelationSelectButtonItem>.State
    var visitedSection: TitleAndItemsWithSingleSelectButton<VisitedSelectButtonItem>.State
    @Shared var editHelper: SpecificEnvelopeHistoryEditHelper

    // TODO: BottomOFCompleteButton(다른 브런치에 있는 것 가져와서 수정)
    init(editHelper: Shared<SpecificEnvelopeHistoryEditHelper>) {
      _editHelper = editHelper

      eventSection = .init(singleSelectButtonHelper: _editHelper.eventSectionButtonHelper)
      relationSection = .init(singleSelectButtonHelper: _editHelper.relationSectionButtonHelper)
      visitedSection = .init(singleSelectButtonHelper: _editHelper.visitedSectionButtonHelper)
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
    case textFieldChanged(String)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case eventSection(TitleAndItemsWithSingleSelectButton<EventSingeSelectButtonItem>.Action)
    case relationSection(TitleAndItemsWithSingleSelectButton<RelationSelectButtonItem>.Action)
    case visitedSection(TitleAndItemsWithSingleSelectButton<VisitedSelectButtonItem>.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.eventSection, action: \.scope.eventSection) {
      TitleAndItemsWithSingleSelectButton()
    }
    Scope(state: \.relationSection, action: \.scope.relationSection) {
      TitleAndItemsWithSingleSelectButton()
    }
    Scope(state: \.visitedSection, action: \.scope.visitedSection) {
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

      case .scope(.relationSection):
        return .none

      case let .view(.textFieldChanged(text)):
        state.editHelper.changeName(text)
        return .none

      case .scope(.visitedSection):
        return .none
      }
    }
  }
}
