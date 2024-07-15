//
//  OnboardingAdditional.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSBottomSelectSheet

// MARK: - OnboardingAdditional

@Reducer
struct OnboardingAdditional {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(type: .depthProgressBar(1)))
    var presentBirthBottomSheet: Bool = false
    var helper: OnboardingAdditionalProperty
    let networkHelper = OnBoardingAdditionalNetwork()
    @Presents var bottomSheet: SSSelectableBottomSheetReducer<BottomSheetYearItem>.State? = nil

    init() {
      helper = .init()
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
    case tappedGenderButton(GenderButtonProperty)
    case tappedBirthButton
    case tappedNextButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case bottomSheet(PresentationAction<SSSelectableBottomSheetReducer<BottomSheetYearItem>.Action>)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case let .view(.tappedGenderButton(item)):
        state.helper.selectItem(item)
        return .none

      case .view(.tappedBirthButton):
        state.bottomSheet =
          .init(
            items: BottomSheetYearItem.makeDefaultItems(),
            selectedItem: state.helper.$selectedBirth
          )
        return .none

      case .scope(.header):
        return .none

      case .view(.tappedNextButton):
        guard let body = SharedStateContainer.getValue(SignUpBodyProperty.self) else {
          return .none
        }
        body.setGender(state.helper.selectedGenderItemToBodyString())
        body.setBirth(state.helper.selectedBirthItemToBodyString())

        return .run { [helper = state.networkHelper] _ in
          let response = try await helper.requestSignUp(body: body)
          OnboardingAdditionalPersistence.saveToken(response)
          NotificationCenter.default.post(name: SSNotificationName.goMainScene, object: nil)
        }
      case .scope(.bottomSheet):
        return .none
      }
    }
    .addFeatures0()
  }
}

extension Reducer where State == OnboardingAdditional.State, Action == OnboardingAdditional.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    ifLet(\.$bottomSheet, action: \.scope.bottomSheet) {
      SSSelectableBottomSheetReducer()
    }
  }
}
