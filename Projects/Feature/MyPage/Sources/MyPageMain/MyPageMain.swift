//
//  MyPageMain.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import AppleLogin
import Combine
import CommonExtension
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSNetwork
import SSNotification
import SSPersistancy

// MARK: - MyPageMain

@Reducer
struct MyPageMain {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
    var isLoading: Bool = false
    var header: HeaderViewFeature.State = .init(.init(title: " ", type: .defaultNonIconType))
    var userInfo: UserInfoResponse = .init(id: 0, name: " ", gender: nil, birth: nil)
    var currentVersionText = MyPageSharedState.shared.getVersion()
    var isLatestVersion: Bool = false

    var topSectionList: IdentifiedArrayOf<MyPageMainItemListCell<TopPageListSection>.State>
      = .init(uniqueElements: TopPageListSection.allCases.map { MyPageMainItemListCell<TopPageListSection>.State(property: $0) })
    var middleSectionList: IdentifiedArrayOf<MyPageMainItemListCell<MiddlePageSection>.State>
      = .init(uniqueElements: MiddlePageSection.default.map { MyPageMainItemListCell<MiddlePageSection>.State(property: $0) })
    var bottomSectionList: IdentifiedArrayOf<MyPageMainItemListCell<BottomPageSection>.State>
      = .init(uniqueElements: BottomPageSection.allCases.map { MyPageMainItemListCell<BottomPageSection>.State(property: $0) })

    var pathState: MyPageRouterAndPathReducer.State = .init()

    init() {}
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
    case tappedFeedbackButton
    case tappedMyPageInformationSection
    case tappedLogOut
    case tappedResignButton
  }

  func viewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
    switch action {
    case .tappedFeedbackButton:
      MyPageRouterAndPathPublisher.route(.feedBack)
      return .none

    case .tappedMyPageInformationSection:
      let myPageInformationState = MyPageInformation.State()
      return .send(.scope(.pathAction(.push(.myPageInfo(myPageInformationState)))))

    case let .onAppear(isAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isAppear
      return .merge(
        .send(.async(.getMyInformation)),
        .send(.scope(.pathAction(.sinkPublisher)))
      )

    case .tappedLogOut:
      return .send(.async(.logout))

    case .tappedResignButton:
      return .send(.async(.resign))
    }
  }

  enum InnerAction: Equatable {
    case updateMyInformation(UserInfoResponse)
    case isLoading(Bool)
    case pushOnboarding
    case updateIsShowUpdateSUSUVersion(String?)
  }

  private func handleBottomSection(_: inout State, section: BottomPageSection) -> Effect<Action> {
    switch section {
    case .logout:
      MyPageRouterAndPathPublisher.route(.logout)
      return .none
    case .resign:
      MyPageRouterAndPathPublisher.route(.resign)
      return .none
    }
  }

  /// InnerAction 처리 함수
  func innerAction(_ state: inout State, _ action: Action.InnerAction) -> Effect<Action> {
    switch action {
    case let .updateMyInformation(dto):
      state.userInfo = dto
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none

    case .pushOnboarding:
      NotificationCenter.default.post(name: SSNotificationName.logout, object: nil)
      SSTokenManager.shared.removeToken()
      return .none

    case let .updateIsShowUpdateSUSUVersion(version):
      state.isLatestVersion = (version == state.currentVersionText)
      if let appVersionStateID = state.middleSectionList.first(where: { $0.property.type == .appVersion })?.id {
        let subtitle = state.isLatestVersion ? state.currentVersionText : "업데이트 하기"
        return .send(.scope(.middleSectionList(.element(id: appVersionStateID, action: .updateSubtitle(subtitle)))))
      }
      return .none
    }
  }

  enum AsyncAction: Equatable {
    case getMyInformation
    case logout
    case resign
  }

  /// AsyncAction 처리 함수
  func asyncAction(_ state: inout State, _ action: Action.AsyncAction) -> Effect<Action> {
    switch action {
    case .getMyInformation:
      if let info = MyPageSharedState.shared.getMyUserInfoDTO() {
        return .send(.inner(.updateMyInformation(info)))
      }
      state.isLoading = true
      return .ssRun { send in
        let dto = try await network.getMyInformation()
        MyPageSharedState.shared.setUserInfoResponseDTO(dto)
        await send(.inner(.updateMyInformation(dto)))
        let version = try await network.getAppstoreVersion()
        await send(.inner(.updateIsShowUpdateSUSUVersion(version)))
        await send(.inner(.isLoading(false)))
      }

    case .logout:
      return .ssRun { send in
        try? await network.logout()
        await send(.inner(.pushOnboarding))
      }

    case .resign:
      return .ssRun { send in
        do {
          let OAuthType = SSOAuthManager.getOAuthType() ?? .KAKAO
          switch OAuthType {
          case .APPLE:
            let appleIdentityToken = LoginWithApple.identityToken
            try await network.resignWithApple(appleIdentityToken)
          case .KAKAO:
            try await network.resign()
          case .GOOGLE:
            break
          }
        } catch {
          os_log(.fault, "\(error.localizedDescription)")
        }
        await send(.inner(.pushOnboarding))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
    case topSectionList(IdentifiedActionOf<MyPageMainItemListCell<TopPageListSection>>)
    case middleSectionList(IdentifiedActionOf<MyPageMainItemListCell<MiddlePageSection>>)
    case bottomSectionList(IdentifiedActionOf<MyPageMainItemListCell<BottomPageSection>>)
    case pathAction(MyPageRouterAndPathReducer.Action)
  }

  /// ScopeAction 처리 함수
  func scopeAction(_ state: inout State, _ action: Action.ScopeAction) -> Effect<Action> {
    switch action {
    case .pathAction:
      return .none

    case .header,
         .tabBar:
      return .none

    // TopSection
    case let .topSectionList(.element(id: id, action: .tapped)):
      if let currentSection = TopPageListSection(rawValue: id) {
        return handleTopSection(&state, section: currentSection)
      }
      return .none

    case .topSectionList:
      return .none

    case let .middleSectionList(.element(id: id, action: .tapped)):
      if let currentSection = MiddlePageSectionType(rawValue: id) {
        return handleMiddleSection(&state, section: currentSection)
      }
      return .none

    // MiddleSectionList
    case .middleSectionList:
      return .none
    case let .bottomSectionList(.element(id: id, action: .tapped)):
      if let currentSection = BottomPageSection(rawValue: id) {
        return handleBottomSection(&state, section: currentSection)
      }
      return .none

    case .bottomSectionList:
      return .none
    }
  }

  enum DelegateAction: Equatable {}

  @Dependency(\.myPageMainNetwork) var network

  var body: some Reducer<State, Action> {
    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.pathState, action: \.scope.pathAction) {
      MyPageRouterAndPathReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      }
    }
    .subFeatures0()
  }
}

extension Reducer where State == MyPageMain.State, Action == MyPageMain.Action {
  func subFeatures0() -> some ReducerOf<Self> {
    forEach(\.topSectionList, action: \.scope.topSectionList) {
      MyPageMainItemListCell()
    }
    .forEach(\.middleSectionList, action: \.scope.middleSectionList) {
      MyPageMainItemListCell()
    }
  }
}

extension MyPageMain {
  private func handleTopSection(_: inout State, section: TopPageListSection) -> Effect<Action> {
    switch section {
    case .privacyPolicy:
      MyPageRouterAndPathPublisher.route(.privacyPolicy)
      return .none
    }
  }

  private func handleMiddleSection(_ state: inout State, section: MiddlePageSectionType) -> Effect<Action> {
    switch section {
    case .appVersion:
      if !state.isLatestVersion {
        SSCommonRouting.openAppStore()
      }
      return .none
    }
  }
}
