//
//  OnboardingRegisterName.swift
//  Onboarding
//
//  Created by MaraMincho on 6/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import FeatureAction

@Reducer
struct OnboardingRegisterName {
  @ObservableState
  struct State: Equatable {
    @Shared var textFieldProperty: SSTextFieldReducerProperty
    var textField: SSTextFieldReducer.State
    var header: HeaderViewFeature.State = .init(.init(type: .depthProgressBar(0.5)))
    var isOnAppear: Bool = false

    var isActiveNextButton: Bool {
      return textFieldProperty.getText != ""
    }

    init() {
      _textFieldProperty = .init(
        SSTextFieldReducerProperty(
          text: "",
          maximumTextLength: 10,
          regexPattern: .SSNameRegexString,
          placeHolderText: .account,
          errorMessage: "한글과 영문 10자 이내로 작성해주세요"
        )
      )
      textField = .init(property: _textFieldProperty)
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
    case tappedNextButton
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case textField(SSTextFieldReducer.Action)
    case header(HeaderViewFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.textField, action: \.scope.textField) {
      SSTextFieldReducer()
    }

    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .view(.tappedNextButton):
        guard let signupObject = SharedStateContainer.getValue(SignUpBodyProperty.self) else {
          return .none
        }
        signupObject.setName(state.textFieldProperty.getText)
        SharedStateContainer.setValue(signupObject)
        OnboardingRouterPublisher.shared.send(.additional(.init()))
        return .none

      case .scope(.textField):
        return .none

      case .scope(.header):
        return .none
      }
    }
  }
}
