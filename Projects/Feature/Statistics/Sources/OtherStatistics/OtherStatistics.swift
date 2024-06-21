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

// MARK: - OtherStatistics

@Reducer
struct OtherStatistics {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var price: Int = 3000
    @Shared var helper: OtherStatisticsProperty
    @Presents var agedBottomSheet: SelectBottomSheet<AgedBottomSheetProperty>.State? = nil
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
  }

  enum InnerAction: Equatable {
    case setInitialHistoryData
    case setHistoryData
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case agedBottomSheet(PresentationAction<SelectBottomSheet<AgedBottomSheetProperty>.Action>)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .run { send in
          await send(.inner(.setInitialHistoryData))
          await send(.inner(.setHistoryData), animation: .linear(duration: 0.8))
        }

      case .inner(.setHistoryData):
        state.helper.setHistoryData()
        return .none

      case .inner(.setInitialHistoryData):
        state.helper.setInitialHistoryData()
        return .none

      case .view(.tappedButton):
        let nextValue = (5000 ... 50000).randomElement()!
        state.price = nextValue
        return .none

      case .view(.tappedRelationshipButton):
        state.helper.fakeSetRelationship()
        return .none

      case .binding:
        return .none

      case .view(.tappedAgedButton):
        state.agedBottomSheet = .init(property: state.$helper.agedBottomSheetProperty)
        return .none
      case .scope(.agedBottomSheet):
        return .none
      }
    }
    .addFeatures0()
  }
}

extension Reducer where State == OtherStatistics.State, Action == OtherStatistics.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    ifLet(\.$agedBottomSheet, action: \.scope.agedBottomSheet) {
      SelectBottomSheet()
    }
  }
}

// MARK: - AgedBottomSheetProperty

struct AgedBottomSheetProperty: SelectBottomSheetPropertyItemable {
  var description: String
  var id: Int
}
