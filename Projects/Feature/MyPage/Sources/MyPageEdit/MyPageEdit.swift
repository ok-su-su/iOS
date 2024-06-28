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

// MARK: - MyPageEdit

@Reducer
struct MyPageEdit {
  var routingPublisher: PassthroughSubject<Routing, Never> = .init()
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "내정보", type: .depth2Text("등록")))
    var tabBar: SSTabBarFeature.State = .init(tabbarType: .mypage)
    var helper: MyPageEditHelper = .init()
    var selectYearIsPresented: Bool = false
    var selectYear: SelectYearBottomSheet.State?

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
      case .scope(.header(.tappedTextButton)):
        // TODO: 저장버튼 눌렀을 때 어떤 변화가 생겨야할지
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
        if present == true {
          state.selectYearIsPresented = true
          state.selectYear = .init(originalYear: state.helper.birthDayDate)
        } else {
          state.selectYearIsPresented = false
          state.selectYear = nil
        }

        return .none

      case let .scope(.selectYear(.tappedYear(title))):
        state.selectYearIsPresented = false
        state.helper.setEditDate(by: title)
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
  }
}
