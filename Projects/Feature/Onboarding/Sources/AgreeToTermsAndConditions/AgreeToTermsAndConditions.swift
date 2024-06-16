//
//  AgreeToTermsAndConditions.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import OSLog

@Reducer
struct AgreeToTermsAndConditions {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var viewDidLoad: Bool = false
    var header = HeaderViewFeature.State(.init(title: "약관 동의", type: .defaultType))
    var helper: AgreeToTermsAndConditionsHelper
    let networkHelper = AgreeToTermsAndConditionsNetworkHelper()
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
    case viewDidLoad(Bool)
    case onAppear(Bool)
    case tappedTermDetailButton(TermItem)
    case tappedCheckBox(TermItem)
    case checkAllTerms
    case tappedNextScreenButton
  }

  enum InnerAction: Equatable {
    case showTermItems([TermItem])
    case showDetailTerms(id: Int, description: String)
  }

  enum AsyncAction: Equatable {
    case getRequestTermsInformation
    case getRequestTermsInformationDetail(id: Int)
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

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
        OnboardingRouterPublisher.shared.send(.registerName(.init()))
        return .none

      case let .async(.getRequestTermsInformationDetail(id)):
        guard let item = state.helper.$termItems[id: id] else {
          return .none
        }

        return .run { [helper = state.networkHelper, item] send in
          let description = try await helper.requestTermsInformationDetail(id: item.id).description
          await send(.inner(.showDetailTerms(id: id, description: description)))
        }

      case .async(.getRequestTermsInformation):
        return .run(priority: .high) { [helper = state.networkHelper] send in
          let dto = try await helper.requestTermsInformation()
          await send(.inner(.showTermItems(.makeBy(dto: dto))))
        }

      case let .inner(.showTermItems(items)):
        items.forEach { item in state.helper.termItems.append(item) }
        return .none

      case let .inner(.showDetailTerms(id: id, description: description)):
        guard let item = state.helper.$termItems[id: id] else {
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
      }
    }
  }
}
