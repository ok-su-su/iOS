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
import SSAlert
import SSBottomSelectSheet

// MARK: - OtherStatistics

@Reducer
struct OtherStatistics {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var price: Int = 3000
    var isLoading: Bool = true
    @Shared var helper: OtherStatisticsProperty
    @Presents var agedBottomSheet: SSSelectableBottomSheetReducer<Age>.State? = nil
    @Presents var relationBottomSheet: SSSelectableBottomSheetReducer<RelationBottomSheetItem>.State? = nil
    @Presents var categoryBottomSheet: SSSelectableBottomSheetReducer<CategoryBottomSheetItem>.State? = nil
    init() {
      _helper = .init(.init())
    }

    var presentMyPageEditAlert: Bool = false
  }

  enum Action: BindableAction, Equatable, FeatureAction {
    case binding(BindingAction<State>)
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedButton
    case tappedAgedButton
    case tappedRelationshipButton
    case tappedCategoryButton
    case presentMyPageEditAlert(Bool)
    case tappedAlertButton
    case tappedScrollView
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .send(.async(.initialUpdateSUSUStatistics))

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

    case let .presentMyPageEditAlert(val):
      state.presentMyPageEditAlert = val
      return .none

    case .tappedAlertButton:
      NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: <#T##Any?#>)
      return .none

    case .tappedScrollView:
      if state.helper.isEmptyState {
        state.presentMyPageEditAlert = true
      }

      return .none
    }
  }

  enum InnerAction: Equatable {
    case updateRelationItems([RelationBottomSheetItem])
    case updateCategoryItems([CategoryBottomSheetItem])
    case isLoading(Bool)
    case updateAged(Int)
    case updateSUSUStatistics(SUSUEnvelopeStatisticResponse)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .updateRelationItems(val):
      state.helper.updateRelationItem(val)
      return .none

    case let .updateCategoryItems(val):
      state.helper.updateCategoryItem(val)
      return .none

    case let .updateAged(val):
      state.helper.selectedAgeItem = .aged(birthYear: val)
      return .none

    case let .updateSUSUStatistics(val):
      state.helper.updateSUSUStatistics(val)
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case initialUpdateSUSUStatistics
    case updateSUSUStatistics
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
      return .run { send in
        await send(.inner(.isLoading(true)))

        let response = try await network.getSUSUStatistics(param)
        await send(.inner(.updateSUSUStatistics(response)))

        await send(.inner(.isLoading(false)))
      }

    case .initialUpdateSUSUStatistics:
      return .run { send in
        // update Value
        guard let birth = try await network.getMyBirth() else {
          return
        }
        await send(.inner(.updateAged(birth)))

        // update Items
        let (relationItems, categoryItems) = try await network.getRelationAndCategory()
        await send(.inner(.updateRelationItems(relationItems)))
        await send(.inner(.updateCategoryItems(categoryItems)))

        // update SUSU statistics
        await send(.async(.updateSUSUStatistics))
      }
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
    case .agedBottomSheet(.presented(.tapped(item: _))),
         .categoryBottomSheet(.presented(.tapped(item: _))),
         .relationBottomSheet(.presented(.tapped(item: _))):
      return .send(.async(.updateSUSUStatistics))
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
