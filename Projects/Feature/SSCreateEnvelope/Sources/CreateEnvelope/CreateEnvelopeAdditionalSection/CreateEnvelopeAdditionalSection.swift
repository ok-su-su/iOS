//
//  CreateEnvelopeAdditionalSection.swift
//  Sent
//
//  Created by MaraMincho on 5/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation

@Reducer
struct CreateEnvelopeAdditionalSection {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var createEnvelopeSelectionItems: CreateEnvelopeSelectItems<CreateEnvelopeAdditionalSectionProperty>.State
    var pushable: Bool = true

    init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.additionalSectionHelper.defaultItems,
        selectedID: createEnvelopeProperty.additionalSectionHelper.selectedID,
        isCustomItem: .init(nil)
      )
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
    case tappedNextButton
  }

  enum InnerAction: Equatable {
    case push
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case createEnvelopeSelectionItems(CreateEnvelopeSelectItems<CreateEnvelopeAdditionalSectionProperty>.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      // TODO: 다른 로직 생각
      CreateEnvelopeSelectItems<CreateEnvelopeAdditionalSectionProperty>(multipleSelectionCount: 20)
    }
    Reduce { _, action in
      switch action {
      case .view(.onAppear):
        CreateEnvelopeRequestShared.resetAdditional()
        return .none
      case .view(.tappedNextButton):
        return .send(.inner(.push))

      case .scope(.createEnvelopeSelectionItems(.delegate(.selected(id: _)))):
        return .none

      case .scope(.createEnvelopeSelectionItems):
        return .none

      case .inner(.push):
        CreateAdditionalRouterPublisher.shared.push(from: .selectSection)
        return .none

      }
    }
  }
}
