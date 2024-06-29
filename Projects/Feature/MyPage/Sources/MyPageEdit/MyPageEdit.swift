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
    var selectedGender: Gender?
    var nameTextFieldText: String = ""
    @Presents var bottomSheet: SSSelectableBottomSheetReducer<SelectYearBottomSheetItem>.State?
    @Shared var selectedBottomSheetItem: SelectYearBottomSheetItem?
    var header: HeaderViewFeature.State = .init(.init(title: "내정보", type: .depth2NonIconType))
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var isPushable: Bool {
      if (userInfo.name != nameTextFieldText) ||
        (userInfo.gender != selectedGender?.genderIdentifierString) ||
        (userInfo.birth != selectedBottomSheetItem?.id) {
        return true
      }
      return false
    }

    var nameText: String {
      userInfo.name
    }

    var yearText: String {
      selectedBottomSheetItem?.description ?? CustomDateFormatter.getYear(from: .now)
    }

    init() {
      userInfo = MyPageSharedState.shared.getMyUserInfoDTO() ?? .init(id: 0, name: "", gender: "M", birth: 1965)
      _selectedBottomSheetItem = .init(nil)
    }

    init(_ userInfo: UserInfoResponseDTO) {
      self.userInfo = userInfo
      _selectedBottomSheetItem = .init(nil)
    }
  }

  @CasePathable
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
    case tappedEditConfirmButton
  }

  enum InnerAction: Equatable {
    /// 초기 TextField, BirthField, GenderField를 설정합니다.
    case updateInitialProperty
    case updateUserInformation
  }

  enum AsyncAction: Equatable {
    case updateUserInformation
  }

  @CasePathable
  enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)
    case toast(SSToastReducer.Action)
    case bottomSheet(PresentationAction<SSSelectableBottomSheetReducer<SelectYearBottomSheetItem>.Action>)
  }

  enum DelegateAction: Equatable {}

  enum Routing: Equatable {
    case dismiss
  }

  var viewAction: (_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> = { state, action in
    switch action {
    case let .onAppear(isOnAppear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = isOnAppear
      return .send(.inner(.updateInitialProperty))

    case let .selectGender(gender):
      state.selectedGender = gender
      return .none

    case let .nameEdited(text):
      state.nameTextFieldText = text
      return .none

    case .selectedYearItem:
      state.bottomSheet = .init(
        items: .default,
        selectedItem: state.$selectedBottomSheetItem
      )
      return .none
    case .tappedEditConfirmButton:
      return .send(.async(.updateUserInformation))
    }
  }

  @Dependency(\.dismiss) var dismiss
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
      case let .view(currentAction):
        return viewAction(&state, currentAction)

      case .scope(.header):
        return .none

      case .scope(.tabBar):
        return .none

      case let .route(destination):
        routingPublisher.send(destination)
        return .none

      case .scope(.toast):
        return .none

      case .scope(.bottomSheet(_)):
        return .none

      case .inner(.updateInitialProperty):

        if let birth = state.userInfo.birth {
          state.selectedBottomSheetItem = .init(description: birth.description, id: birth)
        }

        if let genderString = state.userInfo.gender {
          state.selectedGender = .initByString(genderString)
        }

        let name = state.userInfo.name
        return .send(.view(.nameEdited(name)))
      case .inner(.updateUserInformation):
        return .run { send in
          await send(.async(.updateUserInformation))
          await dismiss()
        }

      case .async(.updateUserInformation):
        let updateName = state.nameTextFieldText
        let gender = state.selectedGender?.genderIdentifierString
        let birth = state.selectedBottomSheetItem?.id
        let requestBody: UpdateUserProfileRequestBody = .init(
          name: updateName,
          gender: gender,
          birth: birth
        )
        return .run { [id = state.userInfo.id] send in
          let dto = try await network.updateUserInformation(userID: id, requestBody: requestBody)
          MyPageSharedState.shared.setUserInfoResponseDTO(dto)
        }
      }
    }
    .activateScope()
  }
}

extension Reducer where Self.State == MyPageEdit.State, Self.Action == MyPageEdit.Action {
  func activateScope() -> some ReducerOf<Self> {
    ifLet(\.$bottomSheet, action: \.scope.bottomSheet) {
      SSSelectableBottomSheetReducer()
    }
  }
}

extension [SelectYearBottomSheetItem] {
  static var `default`: Self {
    return (1930 ... Int(CustomDateFormatter.getYear(from: .now))!)
      .map { .init(description: $0.description + "년", id: $0) }
      .reversed()
  }
}

// MARK: - SelectYearBottomSheetItem

struct SelectYearBottomSheetItem: SSSelectBottomSheetPropertyItemable {
  /// BottomSheet의 Title을 나타냅니다. 연도 + "년"으로 만들어 집니다.
  var description: String
  /// BottomSheet에 표시될 연도 입니다.
  var id: Int
}
