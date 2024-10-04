//
//  AgreeToTermsAndConditions.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog

@Reducer
struct AgreeToTermsAndConditions: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isLoading = true
    var isOnAppear = false
    var viewDidLoad: Bool = false
    var header = HeaderViewFeature.State(.init(title: "약관 동의", type: .depth2NonIconType))
    var helper: AgreeToTermsAndConditionsHelper
    init() {
      helper = .init()
    }
  }

  @Dependency(\.agreeToTermsAndConditionsNetwork) var network

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable, Sendable {
    case viewDidLoad(Bool)
    case onAppear(Bool)
    case tappedTermDetailButton(TermItem)
    case tappedCheckBox(TermItem)
    case checkAllTerms
    case tappedNextScreenButton
  }

  enum InnerAction: Equatable, Sendable {
    case isLoading(Bool)
    case showTermItems([TermItem])
    case showDetailTerms(id: Int, description: String)
    case setSignUpBodyAtSharedStateContainer
  }

  enum AsyncAction: Equatable, Sendable {
    case getRequestTermsInformation
    case getRequestTermsInformationDetail(id: Int)
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable, Sendable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .none

      case let .view(.tappedTermDetailButton(item)):
        return .send(.async(.getRequestTermsInformationDetail(id: item.id)))

      case .scope(.header):
        return .none
      case let .view(.tappedCheckBox(item)):
        state.helper.check(item)
        return .none

      case .view(.checkAllTerms):
        state.helper.checkAllItems()
        return .none

      case .view(.tappedNextScreenButton):
        return .ssRun { send in
          await send(.inner(.setSignUpBodyAtSharedStateContainer))

          // Navigation
          OnboardingRouterPublisher.shared.send(.registerName(.init()))
        }

      case let .async(.getRequestTermsInformationDetail(id)):
        guard let item = Shared(state.helper.$termItems[id: id]) else {
          return .none
        }

        return .ssRun { [item] send in
          let description = try await network.requestTermsInformationDetail(item.id).description
          await send(.inner(.showDetailTerms(id: id, description: description)))
        }

      case .async(.getRequestTermsInformation):
        return .ssRun(priority: .high) { send in
          await send(.inner(.isLoading(true)))
          do {
            let dto = try await network.requestTermsInformation()
            await send(.inner(.showTermItems(.makeBy(dto: dto))))
          }
          await send(.inner(.isLoading(false)))
        }

      case let .inner(.showTermItems(items)):
        items.forEach { item in state.helper.termItems.append(item) }
        return .none

      case let .inner(.showDetailTerms(id: id, description: description)):
        guard let item = Shared(state.helper.$termItems[id: id]) else {
          return .none
        }

        OnboardingRouterPublisher.shared.send(.termDetail(.init(item: item, detailDescription: description)))
        return .none
      case let .view(.viewDidLoad(value)):
        if state.viewDidLoad {
          return .none
        }
        state.viewDidLoad = value
        return .send(.async(.getRequestTermsInformation))

      case let .inner(.isLoading(val)):
        state.isLoading = val
        return .none

      case .inner(.setSignUpBodyAtSharedStateContainer):
        // Container 저장
        let signupBodyProperty = SharedStateContainer.getValue(SignUpBodyProperty.self) ?? .init()
        signupBodyProperty.setTermAgreement(terms: state.helper.checkItemsID())
        SharedStateContainer.setValue(signupBodyProperty)
        return .none
      }
    }
  }
}
