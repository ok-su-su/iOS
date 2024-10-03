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
import SSSelectableItems

@Reducer
public struct CreateEnvelopeAdditionalSection {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var createEnvelopeSelectionItems: SSSelectableItemsReducer<CreateEnvelopeAdditionalSectionProperty>.State
    var pushable: Bool = true

    public init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>, createType: CreateType = .default) {
      _createEnvelopeProperty = createEnvelopeProperty
      createEnvelopeSelectionItems = .init(
        items: createEnvelopeProperty.additionalSectionHelper.defaultItems,
        selectedID: createEnvelopeProperty.additionalSectionHelper.selectedID,
        isCustomItem: .init(nil),
        multipleSelectionCount: 20
      )
      // Set View Defaults Item
      updateDefaultsItem(createType)
    }

    private mutating func updateDefaultsItem(_ createType: CreateType) {
      createEnvelopeProperty.additionalSectionHelper.updateAdditionalSectionItems(createType.toCreateEnvelopeAdditionalSectionProperty)
    }

    public enum CreateType: Equatable {
      case `default`
      case items([CreateEnvelopeAdditionalSectionSceneType])

      var toCreateEnvelopeAdditionalSectionProperty: [CreateEnvelopeAdditionalSectionProperty] {
        switch self {
        case .default:
          CreateEnvelopeAdditionalSectionSceneType.allCases.map { .init(type: $0) }
        case let .items(items):
          items.map { .init(type: $0) }
        }
      }
    }
  }

  public enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedNextButton
  }

  public enum InnerAction: Equatable, Sendable {
    case push
  }

  public enum AsyncAction: Equatable, Sendable {}

  @CasePathable
  public enum ScopeAction: Equatable, Sendable {
    case createEnvelopeSelectionItems(SSSelectableItemsReducer<CreateEnvelopeAdditionalSectionProperty>.Action)
  }

  public enum DelegateAction: Equatable, Sendable {}

  public var body: some Reducer<State, Action> {
    Scope(state: \.createEnvelopeSelectionItems, action: \.scope.createEnvelopeSelectionItems) {
      // TODO: 다른 로직 생각
      SSSelectableItemsReducer<CreateEnvelopeAdditionalSectionProperty>()
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
