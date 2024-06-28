//
//  MyPageMain.swift
//  Profile
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Combine
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation

// MARK: - MyPageMain

@Reducer
struct MyPageMain {
  var routingPublisher: PassthroughSubject<Routing, Never> = .init()

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
    var header: HeaderViewFeature.State = .init(.init(type: .defaultType))

    var topSectionList: IdentifiedArrayOf<MyPageMainItemListCell<TopPageListSection>.State>
      = .init(uniqueElements: TopPageListSection.allCases.map { MyPageMainItemListCell<TopPageListSection>.State(property: $0) })
    var middleSectionList: IdentifiedArrayOf<MyPageMainItemListCell<MiddlePageSection>.State>
      = .init(uniqueElements: MiddlePageSection.allCases.map { MyPageMainItemListCell<MiddlePageSection>.State(property: $0) })
    var bottomSectionList: IdentifiedArrayOf<MyPageMainItemListCell<BottomPageSection>.State>
      = .init(uniqueElements: BottomPageSection.allCases.map { MyPageMainItemListCell<BottomPageSection>.State(property: $0) })

    init() {}
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
    case route(Routing)
  }

  enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedFeedbackButton
    case tappedMyPageInformationSection
  }

  enum InnerAction: Equatable {
    case topSection(TopPageListSection)
    case middleSection(MiddlePageSection)
    case bottomSection(BottomPageSection)
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
    case topSectionList(IdentifiedActionOf<MyPageMainItemListCell<TopPageListSection>>)
    case middleSectionList(IdentifiedActionOf<MyPageMainItemListCell<MiddlePageSection>>)
    case bottomSectionList(IdentifiedActionOf<MyPageMainItemListCell<BottomPageSection>>)
  }

  enum DelegateAction: Equatable {}

  enum Routing: Equatable {
    case myPageInformation
    case connectedSocialAccount
    case exportExcel
    case privacyPolicy
    case appVersion
    case logout
    case resign
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case .scope(.tabBar):
        return .none

      case .scope(.header):
        return .none

      case let .scope(.topSectionList(.element(id: id, action: .tapped))):
        if let currentSection = TopPageListSection(rawValue: id) {
          return .send(.inner(.topSection(currentSection)))
        }
        return .none

      case .scope(.topSectionList):
        return .none

      // TopSection Routing
      case let .inner(.topSection(section)):
        switch section {
        case .connectedSocialAccount:
          routingPublisher.send(.connectedSocialAccount)
        case .exportExcel:
          routingPublisher.send(.exportExcel)
        case .privacyPolicy:
          routingPublisher.send(.privacyPolicy)
        }
        return .none

      case let .scope(.middleSectionList(.element(id: id, action: .tapped))):
        if let currentSection = MiddlePageSection(rawValue: id) {
          return .send(.inner(.middleSection(currentSection)))
        }
        return .none

      case .scope(.middleSectionList):
        return .none

      // Middle Section Routing
      case let .inner(.middleSection(currentSection)):
        switch currentSection {
        case .appVersion: // NavigationSomeSection
          routingPublisher.send(.appVersion)
          return .none
        }

      case let .scope(.bottomSectionList(.element(id: id, action: .tapped))):
        if let currentSection = BottomPageSection(rawValue: id) {
          return .send(.inner(.bottomSection(currentSection)))
        }
        return .none

      case .scope(.bottomSectionList):
        return .none

      // BottomSection Routing
      case let .inner(.bottomSection(currentSection)):
        switch currentSection {
        case .logout:
          routingPublisher.send(.logout)
          return .none

        case .resign:
          routingPublisher.send(.resign)
          return .none
        }

      // TODO: Routing FeedBackPage
      case .view(.tappedFeedbackButton):
        return .none

      case let .route(next):
        routingPublisher.send(next)
        return .none

      case .view(.tappedMyPageInformationSection):
        return .send(.route(.myPageInformation))
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

// MARK: MyPageMain.TopPageListSection

extension MyPageMain {
  enum TopPageListSection: Int, Identifiable, Equatable, CaseIterable, MyPageMainItemListCellItemable {
    case connectedSocialAccount = 0
    case exportExcel
    case privacyPolicy

    var id: Int {
      return rawValue
    }

    var title: String {
      switch self {
      case .connectedSocialAccount:
        "연결된 소셜 계정"
      case .exportExcel:
        "엑셀 파일 내보내기"
      case .privacyPolicy:
        "개인정보 처리 방침"
      }
    }

    var subTitle: String? { nil }
  }

  enum MiddlePageSection: Int, Identifiable, Equatable, CaseIterable, MyPageMainItemListCellItemable {
    case appVersion = 0

    var id: Int {
      return rawValue
    }

    var title: String {
      switch self {
      case .appVersion:
        "앱 버전"
      }
    }

    var subTitle: String? {
      switch self {
      case .appVersion:
        return "업데이트 하기"
      }
    }
  }

  enum BottomPageSection: Int, Identifiable, Equatable, CaseIterable, MyPageMainItemListCellItemable {
    case logout
    case resign

    var id: Int {
      return rawValue
    }

    var title: String {
      switch self {
      case .logout:
        "로그아웃"
      case .resign:
        "탈퇴하기"
      }
    }

    var subTitle: String? { nil }
  }
}
