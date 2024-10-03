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
import SSEditSingleSelectButton
import SSNetwork
import SSRegexManager
import SSToast

// MARK: - MyPageEdit

@Reducer
struct MyPageEdit {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var userInfo: UserInfoResponse
    var selectedGender: Gender? { genderSectionProperty.selectedItem?.gender }
    @Shared var genderSectionProperty: SingleSelectButtonProperty<GenderSelectButtonItem>
    var genderSection: SingleSelectButtonReducer<GenderSelectButtonItem>.State?
    var nameTextFieldText: String = ""
    @Presents var bottomSheet: SSSelectableBottomSheetReducer<SelectYearBottomSheetItem>.State?
    @Shared var selectedBottomSheetItem: SelectYearBottomSheetItem?
    var header: HeaderViewFeature.State = .init(.init(title: "내정보", type: .depth2NonIconType))
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var isPushable: Bool {
      isNameValid && isChanged
    }

    var isNameValid: Bool {
      RegexManager.isValidName(nameTextFieldText)
    }

    var isChanged: Bool {
      (userInfo.name != nameTextFieldText) ||
        (userInfo.birth != selectedBottomSheetItem?.id) ||
        (userInfo.gender != selectedGender?.genderIdentifierString)
    }

    var nameText: String {
      userInfo.name
    }

    var yearText: String {
      selectedBottomSheetItem?.description ?? CustomDateFormatter.getYear(from: .now) + "년"
    }

    init() {
      let userInfo = MyPageSharedState.shared.getMyUserInfoDTO() ?? .init(id: 0, name: "", gender: nil, birth: nil)
      self.userInfo = userInfo
      _selectedBottomSheetItem = .init(nil)
      let initialSelectedGenderItem = Gender.getGenderByKey(userInfo.gender)
      _genderSectionProperty = .init(
        .init(
          titleText: "성별",
          items: .default,
          isCustomItem: nil,
          initialSelectedID: initialSelectedGenderItem?.id,
          customTextFieldPrompt: nil,
          isEssentialProperty: false
        )
      )
    }

    init(_ userInfo: UserInfoResponse) {
      self.userInfo = userInfo
      _selectedBottomSheetItem = .init(nil)
      let initialSelectedGenderItem = Gender.getGenderByKey(userInfo.gender)
      _genderSectionProperty = .init(
        .init(
          titleText: "성별",
          items: .default,
          isCustomItem: nil,
          initialSelectedID: initialSelectedGenderItem?.id,
          customTextFieldPrompt: nil,
          isEssentialProperty: false
        )
      )
    }
  }

  @CasePathable
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
    case selectGender(Gender)
    case nameEdited(String)
    case selectedYearItem(Bool)
    case tappedEditConfirmButton
  }

  enum InnerAction: Equatable {
    /// 초기 TextField, BirthField, GenderField를 설정합니다.
    case updateInitialProperty
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
    case genderSection(SingleSelectButtonReducer<GenderSelectButtonItem>.Action)
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
      state.genderSectionProperty.selectItem(by: gender.id)
      return .none

    case let .nameEdited(text):
      state.nameTextFieldText = text

      return ToastRegexManager.isShowToastByName(text) ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.name.message)))) : .none

    case .selectedYearItem:
      state.bottomSheet = .init(
        items: .default,
        selectedItem: state.$selectedBottomSheetItem,
        deselectItem: .notSelectedItem
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

    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce {
      state,
        action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)

      case .scope(.header):
        return .none

      case .scope(.tabBar):
        return .none

      case .scope(.toast):
        return .none

      case let .scope(.bottomSheet(.presented(.changedItem(item)))):
        if item == .notSelectedItem {
          state.selectedBottomSheetItem = nil
        }
        return .none

      case .scope(.bottomSheet(_)):
        return .none

      case .inner(.updateInitialProperty):
        if let birth = state.userInfo.birth {
          state.selectedBottomSheetItem = .init(description: birth.description + "년", id: birth)
        }

        let genderString = state.userInfo.gender
        let currentGenderID = Gender.getGenderByKey(genderString)?.id

        state.nameTextFieldText = state.userInfo.name
        state.genderSection = .init(singleSelectButtonHelper: state.$genderSectionProperty)
        return .none

      case .async(.updateUserInformation):
        let updateName = state.nameTextFieldText
        let gender = state.selectedGender?.genderIdentifierString
        let birth = state.selectedBottomSheetItem?.id
        let requestBody: UpdateUserProfileRequestBody = .init(
          name: updateName,
          gender: gender,
          birth: birth
        )
        return .ssRun { [id = state.userInfo.id] _ in
          let dto = try await network.updateUserInformation(id, requestBody)
          MyPageSharedState.shared.setUserInfoResponseDTO(dto)
          await dismiss()
        }

      case .scope(.genderSection):
        return .none
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
    .ifLet(\.genderSection, action: \.scope.genderSection) {
      SingleSelectButtonReducer()
    }
  }
}

extension [SelectYearBottomSheetItem] {
  static var `default`: Self {
    let defaultItems: [SelectYearBottomSheetItem] = (1930 ... Int(CustomDateFormatter.getYear(from: .now))!)
      .map { .init(description: $0.description + "년", id: $0) }
      .reversed()
    return [SelectYearBottomSheetItem.notSelectedItem] + defaultItems
  }
}

extension SelectYearBottomSheetItem {
  static var notSelectedItem: Self {
    let notSelectedID = Int.min
    return SelectYearBottomSheetItem(description: "미선택", id: notSelectedID)
  }
}

// MARK: - SelectYearBottomSheetItem

struct SelectYearBottomSheetItem: SSSelectBottomSheetPropertyItemable {
  /// BottomSheet의 Title을 나타냅니다. 연도 + "년"으로 만들어 집니다.
  var description: String
  /// BottomSheet에 표시될 연도 입니다.
  var id: Int
}

private extension UserInfoResponse {}
