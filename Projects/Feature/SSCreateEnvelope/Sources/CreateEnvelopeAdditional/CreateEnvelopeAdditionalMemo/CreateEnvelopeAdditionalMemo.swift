//
//  CreateEnvelopeAdditonalMemo.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSRegexManager
import SSToast

@Reducer
public struct CreateEnvelopeAdditionalMemo: Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false
    @Shared var memoHelper: CreateEnvelopeAdditionalMemoHelper

    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var pushable = false

    init(memoHelper: Shared<CreateEnvelopeAdditionalMemoHelper>) {
      _memoHelper = memoHelper
    }
  }

  public enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  public enum ViewAction: Equatable, Sendable {
    case onAppear(Bool)
    case textFieldChange(String)
    case isHighlightChanged(Bool)
    case tappedNextButton
  }

  public enum InnerAction: Equatable, Sendable {
    case push
  }

  public enum AsyncAction: Equatable, Sendable {}

  @CasePathable
  public enum ScopeAction: Equatable, Sendable {
    case toast(SSToastReducer.Action)
  }

  public enum DelegateAction: Equatable, Sendable {}

  public var body: some Reducer<State, Action> {
    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case .view(.tappedNextButton):
        return .send(.inner(.push))

      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .send(.view(.textFieldChange("")))

      case .inner(.push):
        CreateEnvelopeRequestShared.setMemo(state.memoHelper.textFieldText)
        CreateAdditionalRouterPublisher.shared.push(from: .memo)
        return .none

      case let .view(.textFieldChange(text)):
        state.memoHelper.textFieldText = text
        let pushable = RegexManager.isValidMemo(text)
        state.pushable = pushable
        return ToastRegexManager.isShowToastByMemo(text) ?
          .send(.scope(.toast(.showToastMessage(DefaultToastMessage.memo.message)))) : .none

      case let .view(.isHighlightChanged(highlight)):
        state.memoHelper.isHighlight = highlight
        return .none

      case .scope(.toast):
        return .none
      }
    }
  }
}
