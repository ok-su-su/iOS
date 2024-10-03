//
//  SpecificEnvelopeEditReducer.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSBottomSelectSheet
import SSEditSingleSelectButton
import SSRegexManager
import SSToast

// MARK: - SpecificEnvelopeEditReducer

@Reducer
public struct SpecificEnvelopeEditReducer: Sendable {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(type: .depth2Default))
    var eventSection: TitleAndItemsWithSingleSelectButton<CreateEnvelopeEventProperty>.State
    var relationSection: TitleAndItemsWithSingleSelectButton<CreateEnvelopeRelationItemProperty>.State
    var visitedSection: TitleAndItemsWithSingleSelectButton<VisitedSelectButtonItem>.State
    @Shared var editHelper: SpecificEnvelopeEditHelper
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))
    var isLoading = false
    @Presents var datePicker: SSDateSelectBottomSheetReducer.State? = nil
    let isShowCategory: Bool

    init(editHelper: SpecificEnvelopeEditHelper, isShowCategory: Bool = true) {
      self.isShowCategory = isShowCategory
      _editHelper = .init(editHelper)
      eventSection = .init(singleSelectButtonHelper: _editHelper.eventSectionButtonHelper)
      relationSection = .init(singleSelectButtonHelper: _editHelper.relationSectionButtonHelper)
      visitedSection = .init(singleSelectButtonHelper: _editHelper.visitedSectionButtonHelper)
    }

    public init(envelopeID: Int64, isShowCategory: Bool = true) async throws {
      let network = EnvelopeNetwork.liveValue
      let helper = try await network.getSpecificEnvelopeHistoryEditHelperBy(envelopeID)
      self.init(editHelper: helper, isShowCategory: isShowCategory)
    }

    var isValidToSave: Bool {
      return editHelper.isValidToSave()
    }
  }

  public enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  public enum ViewAction: Equatable {
    case onAppear(Bool)
    case changePriceTextField(String)
    case changeNameTextField(String)
    case changeGiftTextField(String)
    case changeContactTextField(String)
    case changeMemoTextField(String)
    case tappedSaveButton
    case tappedDatePickerSection
    case tappedDatePickerSaveButton
  }

  public enum InnerAction: Equatable {
    case isLoading(Bool)
  }

  public enum AsyncAction: Equatable {
    case editFriendsAndEnvelope
  }

  @Dependency(\.envelopeNetwork) var network
  @Dependency(\.dismiss) var dismiss
  @CasePathable
  public enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case eventSection(TitleAndItemsWithSingleSelectButton<CreateEnvelopeEventProperty>.Action)
    case relationSection(TitleAndItemsWithSingleSelectButton<CreateEnvelopeRelationItemProperty>.Action)
    case visitedSection(TitleAndItemsWithSingleSelectButton<VisitedSelectButtonItem>.Action)
    case toast(SSToastReducer.Action)
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
  }

  public enum DelegateAction: Equatable {
    case tappedSaveButton(envelopeID: Int64)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.eventSection, action: \.scope.eventSection) {
      TitleAndItemsWithSingleSelectButton()
    }
    Scope(state: \.relationSection, action: \.scope.relationSection) {
      TitleAndItemsWithSingleSelectButton()
    }
    Scope(state: \.visitedSection, action: \.scope.visitedSection) {
      TitleAndItemsWithSingleSelectButton()
    }

    Scope(state: \.toast, action: \.scope.toast) {
      SSToastReducer()
    }

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .delegate(currentAction):
        return delegateAction(&state, currentAction)
      }
    }
    .addFeatures()
  }

  public init() {}
}

// MARK: FeatureViewAction, FeatureInnerAction, FeatureAsyncAction, FeatureScopeAction, FeatureDelegateAction

extension SpecificEnvelopeEditReducer: FeatureViewAction, FeatureInnerAction, FeatureAsyncAction, FeatureScopeAction, FeatureDelegateAction {
  public func delegateAction(_: inout State, _: DelegateAction) -> Effect<Action> {
    return .none
  }

  public func scopeAction(_: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .header:
      return .none

    case .eventSection:
      return .none

    case .relationSection:
      return .none

    case .visitedSection:
      return .none

    case .toast:
      return .none

    case .datePicker:
      return .none
    }
  }

  public func viewAction(_ state: inout State, _ action: ViewAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      state.isOnAppear = isAppear
      return .none

    case let .changeNameTextField(text):
      state.editHelper.changeName(text)
      return state.editHelper.isShowToastByName() ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.name.message)))) : .none

    case let .changeGiftTextField(text):
      state.editHelper.changeGift(text)
      return state.editHelper.isShowToastByGift() ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.gift.message)))) : .none

    case let .changeContactTextField(text):
      state.editHelper.changeContact(text)
      return state.editHelper.isShowToastByContact() ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.contact.message)))) : .none

    case let .changeMemoTextField(text):
      state.editHelper.changeMemo(text)
      return state.editHelper.isShowToastByContact() ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.memo.message)))) : .none

    case let .changePriceTextField(text):
      state.editHelper.changePrice(text)
      return state.editHelper.isShowToastByPrice() ?
        .send(.scope(.toast(.showToastMessage(DefaultToastMessage.price.message)))) : .none

    case .tappedSaveButton:
      return .send(.async(.editFriendsAndEnvelope))

    case .tappedDatePickerSection:
      state.datePicker = .init(
        selectedDate: state.$editHelper.dateEditProperty.date,
        isInitialStateOfDate: state.$editHelper.dateEditProperty.isInitialState
      )
      return .none

    case .tappedDatePickerSaveButton:
      return .send(.scope(.datePicker(.dismiss)))
    }
  }

  public func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .isLoading(val):
      state.isLoading = val
      return .none
    }
  }

  public func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .editFriendsAndEnvelope:
      guard let selectedRelationItem = state.editHelper.relationSectionButtonHelper.selectedItem
      else {
        return .none
      }
      let phoneNumber = state.editHelper.contactEditProperty.contact
      let customItemTitle = state.editHelper.relationSectionButtonHelper.isCustomItem?.relation
      let friendRequestBody = CreateAndUpdateFriendRequest(
        name: state.editHelper.nameEditProperty.textFieldText,
        phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
        relationshipId: selectedRelationItem.id,
        customRelation: customItemTitle
      )

      let friendID = state.editHelper.envelopeDetailProperty.friend.id

      // Envelope Edit Body Properties
      let envelopeType = state.editHelper.envelopeDetailProperty.envelope.type
      let envelopePrice = state.editHelper.priceProperty.price
      guard let selectedCategoryItem = state.editHelper.eventSectionButtonHelper.selectedItem else {
        return .none
      }
      let hasVisited = state.editHelper.visitedSectionButtonHelper.selectedItem?.isVisited
      let handOverAt = CustomDateFormatter.getFullDateString(from: state.editHelper.dateEditProperty.date)
      let customCategory = selectedCategoryItem.id == state.editHelper.eventSectionButtonHelper.isCustomItem?.id ?
        state.editHelper.eventSectionButtonHelper.isCustomItem?.title : nil

      let giftText: String = state.editHelper.giftEditProperty.gift
      let queryGiftText: String? = giftText.isEmpty ? nil : giftText

      let memoText: String = state.editHelper.memoEditProperty.memo
      let queryMemoText: String? = memoText.isEmpty ? nil : memoText
      let category: CreateCategoryAssignmentRequest = .init(id: state.editHelper.eventSectionButtonHelper.selectedItem?.id ?? 0, customCategory: customCategory)

      let envelopeID = state.editHelper.envelopeDetailProperty.envelope.id
      return .ssRun { send in
        await send(.inner(.isLoading(true)))
        let updatedFriendID = try await network.editFriends(friendID, friendRequestBody)

        let envelopeRequestBody = CreateAndUpdateEnvelopeRequest(
          type: envelopeType,
          friendId: updatedFriendID,
          ledgerId: nil,
          amount: envelopePrice,
          gift: queryGiftText,
          memo: queryMemoText,
          hasVisited: hasVisited,
          handedOverAt: handOverAt,
          category: category
        )
        let envelopeProperty = try await network.editEnvelopes(envelopeID, envelopeRequestBody)
        UpdateEnvelopeDetailPropertyPublisher.send(envelopeProperty)
        await send(.delegate(.tappedSaveButton(envelopeID: envelopeID)))
        await dismiss()
        await send(.inner(.isLoading(false)))
      }
    }
  }
}

extension Reducer where State == SpecificEnvelopeEditReducer.State, Action == SpecificEnvelopeEditReducer.Action {
  func addFeatures() -> some Reducer<State, Action> {
    ifLet(\.$datePicker, action: \.scope.datePicker) {
      SSDateSelectBottomSheetReducer()
    }
  }
}
