//
//  OnboardingLogin.swift
//  Onboarding
//
//  Created by MaraMincho on 6/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import KakaoLogin
import OSLog
import SSNotification
import SSPersistancy

@Reducer
struct OnboardingLogin: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var helper: OnboardingLoginHelper = .init()
    init() {}
  }

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case tappedKakaoLoginButton
    case successAppleLogin
  }

  enum InnerAction: Equatable, Sendable {
    case showPieChart
    case showPercentageAndPriceText
    case navigateTermsView
    case initSignUpBodyPropertyInSharedStateContainer(LoginType)
  }

  enum AsyncAction: Equatable, Sendable {
    case loginWithKakaoTalk
    case checkIsNewUser(loginType: LoginType, token: String?)
    case loginWithSUSU(loginType: LoginType, token: String)
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {}

  enum DelegateAction: Equatable, Sendable {}

  private enum CancelID: Sendable {
    case KakaoLogin
    case AppleLogin
  }

  @Dependency(\.onBoardingLoginNetwork) var network
  @Dependency(\.loginTokenManager) var persistence
  @Dependency(\.mainQueue) var mainQueue
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .ssRun { send in
          await send(.inner(.showPieChart))
          await send(.inner(.showPercentageAndPriceText))
        }

      case .inner(.showPieChart):
        state.helper.setSectorShapeProperty()
        return .none

      case .inner(.showPercentageAndPriceText):
        state.helper.setTextProperty()
        return .none

      case .view(.tappedKakaoLoginButton):
        return .send(.async(.loginWithKakaoTalk))
          .throttle(id: CancelID.KakaoLogin, for: .seconds(4), scheduler: mainQueue, latest: false)

      case .view(.successAppleLogin):
        let appleToken = persistence.getToken(.APPLE)
        return .send(.async(.checkIsNewUser(loginType: .APPLE, token: appleToken)))
          .throttle(id: CancelID.AppleLogin, for: .seconds(4), scheduler: mainQueue, latest: false)

      case .async(.loginWithKakaoTalk):
        return .ssRun(priority: .high) { send in
          let isSuccessLoginWithKAKAOTalk = await network.loginWithKakao()
          if isSuccessLoginWithKAKAOTalk {
            let kakaoToken = persistence.getToken(.KAKAO)
            await send(.async(.checkIsNewUser(loginType: .KAKAO, token: kakaoToken)))
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

      case let .async(.checkIsNewUser(loginType: loginType, token: token)):
        guard let token else {
          os_log("토큰값이 유효하지 않습니다. loginType =\(loginType.rawValue)")
          return .none
        }
        // 어떤 로그인을 통해서 들어왔는지 KeyChain에 저장
        SSOAuthManager.setOAuthType(loginType.OAuthType)
        return .ssRun { send in
          // 새로운 유저라면
          if await network.isNewUser(loginType: loginType, token: token) {
            await send(.inner(.initSignUpBodyPropertyInSharedStateContainer(loginType)))
            await send(.inner(.navigateTermsView))
            return
          }
          // 만약 이전에 가입한 유저라면
          await send(.async(.loginWithSUSU(loginType: loginType, token: token)))
        }
      case let .async(.loginWithSUSU(loginType: loginType, token: token)):
        return .ssRun { _ in
          await network.loginWithSUSU(loginType: loginType, token: token)
          NotificationCenter.default.post(name: SSNotificationName.goMainScene, object: nil)
        }
      }
    }
  }
}
