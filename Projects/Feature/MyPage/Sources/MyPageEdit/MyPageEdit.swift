//
//  MyPageEdit.swift
//  MyPage
//
//  Created by MaraMincho on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Combine
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSBottomSelectSheet
import SSToast

// MARK: - MyPageEdit

@Reducer
struct MyPageEdit {
  var routingPublisher: PassthroughSubject<Routing, Never> = .init()
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var userInfo: UserInfoResponseDTO
    var helper: MyPageEditHelper = .init()
    var selectYearIsPresented: Bool = false
    var selectYear: SelectYearBottomSheet.State?
    @Presents var bottomSheet: SSSelectableBottomSheetReducer<SelectYearBottomSheetItem>.State?
    @Shared var selectedBottomSheetItem: SelectYearBottomSheetItem?
    var header: HeaderViewFeature.State = .init(.init(title: "내정보", type: .depth2NonIconType))
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))

    init() {
      userInfo = MyPageSharedState.shared.getMyUserInfoDTO() ?? .init(id: 0, name: "", gender: "M", birth: 1965)
      _selectedBottomSheetItem = .init(nil)
    }

    init(_ userInfo: UserInfoResponseDTO) {
      self.userInfo = userInfo
      _selectedBottomSheetItem = .init(nil)
    }
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
    case route(Routing)
  }

  @CasePathable
  enum ViewAction: Equatable {
    case onAppear(Bool)
    case selectGender(Gender)
    case nameEdited(String)
    case selectedYearItem(Bool)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case selectYear(SelectYearBottomSheet.Action)
    case toast(SSToastReducer.Action)
    case bottomSheet(PresentationAction<SSSelectableBottomSheetReducer<SelectYearBottomSheetItem>.Action>)
  }

  enum DelegateAction: Equatable {}

  enum Routing: Equatable {
    case dismiss
  }

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

      case .scope(.header):
        return .none

      case .scope(.tabBar):
        return .none

      case let .route(destination):
        routingPublisher.send(destination)
        return .none

      case let .view(.nameEdited(text)):
        state.helper.editName(text: text)
        return .none

      case let .view(.selectGender(gender)):
        state.helper.editedValue.gender = gender
        return .none

      case let .view(.selectedYearItem(present)):
        state.bottomSheet = .init(
          items: .default,
          selectedItem: state.$selectedBottomSheetItem
        )
        return .none

      case let .scope(.selectYear(.tappedYear(title))):
        state.selectYearIsPresented = false
        state.helper.setEditDate(by: title)
        return .none

      case .scope(.toast):
        return .none
      case .scope(.bottomSheet(_)):
        return .none
      }
    }
    .activateScope()
  }
}

extension Reducer where Self.State == MyPageEdit.State, Self.Action == MyPageEdit.Action {
  func activateScope() -> some ReducerOf<Self> {
    ifLet(\.selectYear, action: \.scope.selectYear) {
      SelectYearBottomSheet()
    }
    .ifLet(\.$bottomSheet, action: \.scope.bottomSheet) {
      SSSelectableBottomSheetReducer()
    }
  }
}

extension [SelectYearBottomSheetItem] {
  static var `default`: Self {
    return (1930 ... Int(CustomDateFormatter.getYear(from: .now))!)
      .map { .init(description: $0.description, id: $0) }
  }
}

// MARK: - SelectYearBottomSheetItem

struct SelectYearBottomSheetItem: SSSelectBottomSheetPropertyItemable {
  /// BottomSheet의 Title을 나타냅니다.
  var description: String
  /// 아이디 입니다.
  var id: Int
}
