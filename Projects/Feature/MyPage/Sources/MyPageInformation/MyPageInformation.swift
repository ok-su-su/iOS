//
//  MyPageInformation.swift
//  MyPage
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Combine
import ComposableArchitecture
import Designsystem
import Foundation

// MARK: - MyPageInformation

@Reducer
struct MyPageInformation: Reducer {
  var routingPublisher: PassthroughSubject<Routing, Never> = .init()

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "내정보", type: .depth2Text("편집")))
    var listItems: IdentifiedArrayOf<MyPageMainItemListCell<MyPageInformationListItem>.State>
      = .init(uniqueElements: MyPageInformationListItem.allCases.map { MyPageMainItemListCell<MyPageInformationListItem>.State(property: $0) })
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
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
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  enum Routing {
    case editProfile
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case listItems(IdentifiedActionOf<MyPageMainItemListCell<MyPageInformationListItem>>)
    case tabBar(SSTabBarFeature.Action)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case .scope(.header(.tappedTextButton)):
        return .send(.route(.editProfile))

      case .scope(.header):
        return .none

      case .scope(.listItems):
        return .none

      case .scope(.tabBar):
        return .none

      case let .route(destination):
        routingPublisher.send(destination)
        return .none
      }
    }
    .addFeatures0()
  }
}

extension Reducer where State == MyPageInformation.State, Action == MyPageInformation.Action {
  func addFeatures0() -> some ReducerOf<Self> {
    forEach(\.listItems, action: \.scope.listItems) {
      MyPageMainItemListCell()
    }
  }
}

// MARK: - MyPageInformationListItem

enum MyPageInformationListItem: Int, MyPageMainItemListCellItemable, CaseIterable, Equatable {
  case name = 0
  case birthDay = 1
  case gender = 2

  var id: Int {
    return rawValue
  }

  var title: String {
    switch self {
    case .name:
      "이름"
    case .birthDay:
      "생일"
    case .gender:
      "성별"
    }
  }

  var subTitle: String? {
    switch self {
    case .name:
      return "김수수"
    case .birthDay:
      return "2024.02.03"
    case .gender:
      return "대답하고싶지 않음"
    }
  }
}
