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
    
    var topSectionList: IdentifiedArrayOf<MyPageMainItemListCell<TopPageListSection>.State> = {
      return .init(uniqueElements: TopPageListSection.allCases.map{MyPageMainItemListCell<TopPageListSection>.State(property: $0)})
    }()

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
  }

  enum InnerAction: Equatable {
    case topSection(TopPageListSection)
  }

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case tabBar(SSTabBarFeature.Action)
    case header(HeaderViewFeature.Action)
    case topSectionList(IdentifiedActionOf<MyPageMainItemListCell<TopPageListSection>>)
  }

  enum DelegateAction: Equatable {}

  enum Routing: Equatable {
    case myPageInformation
    case connectedSocialAccount
    case exportExcel
    case privacyPolicy
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

      case let .scope(.topSectionList(.element(id: id, action: .tapped))) :
        return .none
        
      case .scope(.topSectionList):
        return .none
        
      //TopSection Routing
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
      }
      
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
}
