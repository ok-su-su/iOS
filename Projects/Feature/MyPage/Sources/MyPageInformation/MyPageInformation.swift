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
import FeatureAction
import Foundation

// MARK: - MyPageInformation

@Reducer
struct MyPageInformation: Reducer {
  var routingPublisher: PassthroughSubject<Routing, Never> = .init()

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var isLoading = false
    var header: HeaderViewFeature.State = .init(.init(title: "내정보", type: .depth2Text("편집")))
    var listItems: IdentifiedArrayOf<MyPageMainItemListCell<MyPageInformationListItem>.State>
      = .init(uniqueElements: [])
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
    var userInfo: UserInfoResponseDTO?
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

  enum InnerAction: Equatable {
    case updateUserInfo(UserInfoResponseDTO)
    case isLoading(Bool)
    case updateCellItems
  }

  enum AsyncAction: Equatable {
    case getMyInformation
  }

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

  @Dependency(\.myPageMainNetwork) var network

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
        state.userInfo = MyPageSharedState.shared.getMyUserInfoDTO()
        // 만약 캐시에 현재 정보가 저장 X 일 경우
        if state.userInfo == nil {
          return .send(.async(.getMyInformation))
        }
        return .send(.inner(.updateCellItems))

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

      case .async(.getMyInformation):
        return .run { send in
          await send(.inner(.isLoading(true)))
          let dto = try await network.getMyInformation()
          await send(.inner(.updateUserInfo(dto)))
          await send(.inner(.updateCellItems))
          await send(.inner(.isLoading(false)))
        }

      case let .inner(.updateUserInfo(info)):
        state.userInfo = info
        return .send(.inner(.updateCellItems))

      case let .inner(.isLoading(val)):
        state.isLoading = val
        return .none

      case .inner(.updateCellItems):
        guard let cellItems = state.userInfo?.makeMyPageInformationListItem() else {
          return .none
        }
        state.listItems = .init(uniqueElements: cellItems)
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

struct MyPageInformationListItem: MyPageMainItemListCellItemable, Equatable {
  var id: Int
  var title: String
  var subTitle: String?
  init(id: Int, title: String, subTitle: String?) {
    self.id = id
    self.title = title
    self.subTitle = subTitle
  }
}

private extension UserInfoResponseDTO {
  func makeMyPageInformationListItem() -> [MyPageMainItemListCell<MyPageInformationListItem>.State] {
    let items = MyPageInformationListItemType.allCases.map { type -> MyPageInformationListItem in
      let content = switch type {
      case .name:
        self.name
      case .birthDay:
        self.birth?.description.appending("년")
      case .gender:
        getGenderText(self.gender)
      }
      return MyPageInformationListItem(id: type.rawValue, title: type.titleString, subTitle: content)
    }
    return items.sorted { $0.id < $1.id }.map { .init(property: $0) }
  }
}

// MARK: - MyPageInformationListItemType

enum MyPageInformationListItemType: Int, Equatable, CaseIterable {
  case name = 0
  case birthDay = 1
  case gender = 2

  var titleString: String {
    switch self {
    case .name:
      "이름"
    case .birthDay:
      "출생년도"
    case .gender:
      "성별"
    }
  }
}

/// "F" 여자, "M" 남자 나머지 ""
private func getGenderText(_ val: String?) -> String {
  switch val {
  case "F":
    "여자"
  case "M":
    "남자"
  default:
    ""
  }
}
