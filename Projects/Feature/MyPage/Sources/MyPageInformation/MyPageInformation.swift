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
    case routEditProfile
  }

  enum AsyncAction: Equatable {}

  enum Routing {
    case editProfile
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case listItems(IdentifiedActionOf<MyPageMainItemListCell<MyPageInformationListItem>>)
  }

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none
      case .scope(.header(.tappedSearchButton)):
        return .none

      case .scope(.header):
        return .none

      case .scope(.listItems):
        return .none
      case .inner(.routEditProfile):
        routingPublisher.send(.editProfile)
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
      return nil
    case .birthDay:
      return nil
    case .gender:
      return nil
    }
  }
}
