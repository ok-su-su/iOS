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
import SSNotification
import SSPersistancy

// MARK: - OnboardingAdditional

@Reducer
struct OnboardingAdditional {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(type: .depthProgressBar(1)))
    var presentBirthBottomSheet: Bool = false
    var helper: OnboardingAdditionalProperty
    var isLoading: Bool = false
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
    case tappedGenderButton(GenderType)
    case tappedBirthButton
    case tappedNextButton
  }

  enum InnerAction: Equatable {
    case isLoading(Bool)
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case bottomSheet(PresentationAction<SSSelectableBottomSheetReducer<BottomSheetYearItem>.Action>)
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.onboardingAdditionalNetwork) var network

  private func handleSignup(send _: Send<Action>) async throws {
    guard let body = SharedStateContainer.getValue(SignUpBodyProperty.self) else {
      return
    }
    let response = try await network.requestSignUp(body)
    try OnboardingAdditionalPersistence.saveToken(response)

    let userID = try await network.requestUserID()
    try await OnboardingAdditionalPersistence.saveUserID(userID)
  }

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
            items: .default,
            selectedItem: state.helper.$selectedBirth,
            deselectItem: .deselectItem
          )
        return .none

      case .scope(.header):
        return .none

      case .view(.tappedNextButton):
        guard let body = SharedStateContainer.getValue(SignUpBodyProperty.self) else {
          return .none
        }
        body.setGender(state.helper.selectedGenderItem)
        body.setBirth(state.helper.selectedBirthItemToBodyString())

        return .ssRun { send in
          await send(.inner(.isLoading(true)))
          do {
            try await handleSignup(send: send)
            NotificationCenter.default.post(name: SSNotificationName.goMainScene, object: nil)
          } catch {
            throw error
          }
          await send(.inner(.isLoading(false)))
        }
      case .scope(.bottomSheet):
        return .none

      case let .inner(.isLoading(val)):
        state.isLoading = val
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
