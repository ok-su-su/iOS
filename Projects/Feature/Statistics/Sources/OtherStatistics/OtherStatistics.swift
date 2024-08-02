//
//  OtherStatistics.swift
//  Statistics
//
//  Created by MaraMincho on 5/25/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSBottomSelectSheet

// MARK: - OtherStatistics

@Reducer
struct OtherStatistics {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var price: Int = 3000
    var isLoading: Bool = false
    @Shared var helper: OtherStatisticsProperty
    @Presents var agedBottomSheet: SSSelectableBottomSheetReducer<Age>.State? = nil
    @Presents var relationBottomSheet: SSSelectableBottomSheetReducer<RelationBottomSheetItem>.State? = nil
    @Presents var categoryBottomSheet: SSSelectableBottomSheetReducer<CategoryBottomSheetItem>.State? = nil
    init() {
      _helper = .init(.init())
    }
  }

  enum Action: BindableAction, Equatable, FeatureAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedButton
    case tappedAgedButton
    case tappedRelationshipButton
    case tappedCategoryButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.getRelationAndCategoryItems))
    case .tappedButton:
      let nextValue = (5000 ... 50000).randomElement()!
      state.price = nextValue
      return .none

    case .tappedAgedButton:
      state.agedBottomSheet = .init(items: Age.allCases, selectedItem: state.$helper.selectedAgeItem)
      return .none

    case .tappedRelationshipButton:
      let items = state.helper.relationItems
      let selectedItem = state.$helper.selectedRelationItem
      state.relationBottomSheet = .init(items: items, selectedItem: selectedItem)
      return .none

    case .tappedCategoryButton:
      let items = state.helper.categoryItems
      let selectedItem = state.$helper.selectedCategoryItem
      state.categoryBottomSheet = .init(items: items, selectedItem: selectedItem)
      return .none
    }
  }

  enum InnerAction: Equatable {
    case setInitialHistoryData
    case setHistoryData
    case updateRelationItems([RelationBottomSheetItem])
    case updateCategoryItems([CategoryBottomSheetItem])
    case isLoading(Bool)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none
    case .setInitialHistoryData:
      state.helper.setHistoryData()
      return .none

    case .setHistoryData:
      state.helper.setInitialHistoryData()
      return .none

    case let .updateRelationItems(val):
      state.helper.relationItems = val
      return .none

    case let .updateCategoryItems(val):
      state.helper.categoryItems = val
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case updateSUSUStatistics
    case getRelationAndCategoryItems
    case getAged
  }

  @Dependency(\.statisticsMainNetwork) var network
  func asyncAction(_ state: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case .updateSUSUStatistics:
      guard let age = state.helper.selectedAgeItem,
            let category = state.helper.selectedCategoryID,
            let relationship = state.helper.selectedRelationshipID
      else {
        return .none
      }
      let param: SUSUStatisticsRequestProperty = .init(
        age: age,
        relationshipId: .init(relationship),
        categoryId: .init(category)
      )
      return .run { _ in
        let response = try await network.getSUSUStatistics(param)
      }

    case .getRelationAndCategoryItems:
      return .run { send in
        await send(.inner(.isLoading(true)))

        let (relationItems, categoryItems) = try await network.getRelationAndCategory()
        await send(.inner(.updateRelationItems(relationItems)))
        await send(.inner(.updateCategoryItems(categoryItems)))

        await send(.inner(.isLoading(false)))
      }

    case .getAged:
      return .none
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case agedBottomSheet(PresentationAction<SSSelectableBottomSheetReducer<Age>.Action>)
    case relationBottomSheet(PresentationAction<SSSelectableBottomSheetReducer<RelationBottomSheetItem>.Action>)
    case categoryBottomSheet(PresentationAction<SSSelectableBottomSheetReducer<CategoryBottomSheetItem>.Action>)
  }

  func scopeAction(_: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case .agedBottomSheet:
      return .none
    case .categoryBottomSheet:
      return .none
    case .relationBottomSheet:
      return .none
    }
  }

  enum DelegateAction: Equatable {
    case routeMyPage
  }

  func delegateAction(_: inout State, _: DelegateAction) -> Effect<Action> {
    return .none
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)

      case let .inner(currentAction):
        return innerAction(&state, currentAction)

      case let .delegate(currentAction):
        return delegateAction(&state, currentAction)

      case let .scope(currentAction):
        return scopeAction(&state, currentAction)

      case let .async(currentAction):
        return asyncAction(&state, currentAction)

      case .binding:
        return .none
      }
    }
    .addFeatures0()
  }
}

extension Reducer where State == OtherStatistics.State, Action == OtherStatistics.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    ifLet(\.$agedBottomSheet, action: \.scope.agedBottomSheet) {
      SSSelectableBottomSheetReducer()
    }
    .ifLet(\.$categoryBottomSheet, action: \.scope.categoryBottomSheet) {
      SSSelectableBottomSheetReducer()
    }
    .ifLet(\.$relationBottomSheet, action: \.scope.relationBottomSheet) {
      SSSelectableBottomSheetReducer()
    }
  }
}
