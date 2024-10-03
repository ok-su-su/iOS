//
//  CreateEnvelopeAdditionalContact.swift
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
public struct CreateEnvelopeAdditionalContact: Sendable {
  @ObservableState
  public struct State: Equatable, Sendable {
    var isOnAppear = false
    @Shared var contactHelper: CreateEnvelopeAdditionalContactHelper
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var pushable = false
    var friendName = CreateFriendRequestShared.getName()

    init(contactHelper: Shared<CreateEnvelopeAdditionalContactHelper>) {
      _contactHelper = contactHelper
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
    case changedTextField(String)
    case changeIsHighlight(Bool)
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
      case let .view(.onAppear(isAppear)):
        state.isOnAppear = isAppear
        return .none

      case let .view(.changedTextField(text)):
        state.contactHelper.textFieldText = text
        let pushable = RegexManager.isValidContacts(text)
        state.pushable = pushable
        return ToastRegexManager.isShowToastByContacts(text) ?
          .send(.scope(.toast(.showToastMessage(DefaultToastMessage.contact.description)))) : .none

      case let .view(.changeIsHighlight(isHighlight)):
        state.contactHelper.isHighlight = isHighlight
        return .none

      case .inner(.push):
        CreateAdditionalRouterPublisher.shared.push(from: .contact)
        CreateFriendRequestShared.setContacts(state.contactHelper.textFieldText)
        return .none

      case .scope(.toast):
        return .none

      case .view(.tappedNextButton):
        return .send(.inner(.push))
      }
    }
  }
}
