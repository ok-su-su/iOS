//
//  OnboardingLogin.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import KakaoLogin
import FeatureAction

@Reducer
struct OnboardingLogin {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var helper: OnboardingLoginHelper = .init()
    var networkHelper = OnboardingLoginNetworkHelper()

    init() {}
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
    case tappedKakaoLoginButton
  }

  enum InnerAction: Equatable {
    case showPieChart
    case showPercentageAndPriceText
    case navigateTermsView
    case initSignUpBodyPropertyInSharedStateContainer(LoginType)
  }

  enum AsyncAction: Equatable {
    case loginWithKakaoTalk
    case checkIsNewUser(loginType: LoginType)
    case loginWithSUSU(loginType: LoginType)
  }

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .run { send in
          await send(.inner(.showPieChart))
          await send(.inner(.showPercentageAndPriceText), animation: .bouncy(duration: 1))
        }

      case .inner(.showPieChart):
        state.helper.setSectorShapeProperty()
        return .none

      case .inner(.showPercentageAndPriceText):
        state.helper.setTextProperty()
        return .none

      case .view(.tappedKakaoLoginButton):
        return .send(.async(.loginWithKakaoTalk))

      case .async(.loginWithKakaoTalk):
        return .run(priority: .high) { [helper = state.networkHelper] send in
          let isSuccessLoginWithKAKAOTalk = await helper.loginWithKakao()
          if isSuccessLoginWithKAKAOTalk {
            await send(.async(.checkIsNewUser(loginType: .KAKAO)))
          }
        }

      case .inner(.navigateTermsView):
        OnboardingRouterPublisher.shared.send(.terms(.init()))
        return .none

      case let .inner(.initSignUpBodyPropertyInSharedStateContainer(val)):
        let property = SignUpBodyProperty()
        property.setLoginType(val)
        SharedStateContainer.setValue(property)
        return .none

      case let .async(.checkIsNewUser(loginType: loginType)):
        return .run { [helper = state.networkHelper] send in
          // 새로운 유저라면
          if await helper.isNewUser(loginType: loginType) {
            await send(.inner(.initSignUpBodyPropertyInSharedStateContainer(.KAKAO)))
            await send(.inner(.navigateTermsView))
            return
          }
          // 만약 이전에 가입한 유저라면
          await send(.async(.loginWithSUSU(loginType: loginType)))
        }
      case let .async(.loginWithSUSU(loginType: loginType)):
        return .run { [helper = state.networkHelper] _ in
          await helper.loginWithSUSU(loginType: loginType)
          NotificationCenter.default.post(name: SSNotificationName.goMainScene, object: nil)
        }
      }
    }
  }
}
