//
//  SpecificEnveEditReducer.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import SSRegexManager
import SSToast

@Reducer
public struct SpecificEnvelopeEditReducer {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    var header = HeaderViewFeature.State(.init(type: .depth2Default))
    var eventSection: TitleAndItemsWithSingleSelectButton<CreateEnvelopeEventProperty>.State
    var relationSection: TitleAndItemsWithSingleSelectButton<CreateEnvelopeRelationItemProperty>.State
    var visitedSection: TitleAndItemsWithSingleSelectButton<VisitedSelectButtonItem>.State
    @Shared var editHelper: SpecificEnvelopeEditHelper
    var toast: SSToastReducer.State = .init(.init(toastMessage: "", trailingType: .none))

    init(editHelper: SpecificEnvelopeEditHelper) {
      _editHelper = .init(editHelper)
      eventSection = .init(singleSelectButtonHelper: _editHelper.eventSectionButtonHelper)
      relationSection = .init(singleSelectButtonHelper: _editHelper.relationSectionButtonHelper)
      visitedSection = .init(singleSelectButtonHelper: _editHelper.visitedSectionButtonHelper)
    }

    public init(envelopeID: Int64) async throws {
      let network = EnvelopeNetwork()
      let helper = try await network.getSpecificEnvelopeHistoryEditHelperBy(envelopeID: envelopeID)
      self.init(editHelper: helper)
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
  }

  public enum InnerAction: Equatable {
    case setInitialValue
  }

  public enum AsyncAction: Equatable {}

  @CasePathable
  public enum ScopeAction: Equatable {
    case header(HeaderViewFeature.Action)
    case eventSection(TitleAndItemsWithSingleSelectButton<CreateEnvelopeEventProperty>.Action)
    case relationSection(TitleAndItemsWithSingleSelectButton<CreateEnvelopeRelationItemProperty>.Action)
    case visitedSection(TitleAndItemsWithSingleSelectButton<VisitedSelectButtonItem>.Action)
    case toast(SSToastReducer.Action)
  }

  public enum DelegateAction: Equatable {}

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
      }
    }
  }

  public init() {}
}

extension SpecificEnvelopeEditReducer: FeatureViewAction, FeatureInnerAction, FeatureAsyncAction, FeatureScopeAction {
  public func scopeAction(_ state: inout State, _ action: ScopeAction) -> ComposableArchitecture.Effect<Action> {
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
    }
  }

  public func viewAction(_ state: inout State, _ action: ViewAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case let .onAppear(isAppear):
      state.isOnAppear = isAppear
      return .send(.inner(.setInitialValue))

    case let .changeNameTextField(text):
      state.editHelper.changeName(text)
      return state.editHelper.isValidName() ? .none :
        .send(.scope(.toast(.showToastMessage("이름은 10글자까지만 입력 가능해요"))))

    case let .changeGiftTextField(text):
      state.editHelper.changeGift(text)
      return state.editHelper.isValidGift() ? .none:
        .send(.scope(.toast(.showToastMessage("선물은 30글자까지만 입력 가능해요"))))

    case let .changeContactTextField(text):
      state.editHelper.changeContact(text)
      return state.editHelper.isValidContact() ? .none :
        .send(.scope(.toast(.showToastMessage("연락처는 11자리까지만 입력 가능해요"))))

    case let .changeMemoTextField(text):
      state.editHelper.changeMemo(text)
      return state.editHelper.isValidMemo() ? .none :
        .send(.scope(.toast(.showToastMessage("메모는 30글자까지만 입력 가능해요"))))

    case let .changePriceTextField(text):
      state.editHelper.changePrice(text)
      return state.editHelper.isValidPrice() ? .none :
        .send(.scope(.toast(.showToastMessage("100억 미만의 금액만 입력 가능해요"))))
    }
  }

  public func innerAction(_ state: inout State, _ action: InnerAction) -> ComposableArchitecture.Effect<Action> {
    switch action {
    case .setInitialValue:
      let initialEvent = state.editHelper.envelopeDetailProperty.eventName
      let initialRelation = state.editHelper.envelopeDetailProperty.relation
      let initialVisited = state.editHelper.envelopeDetailProperty.isVisitedText
      return .run { send in
        await send(.scope(.eventSection(.initialValue(initialEvent))))
        await send(.scope(.relationSection(.initialValue(initialRelation))))
        await send(.scope(.visitedSection(.initialValue(initialVisited ?? ""))))
      }
    }
  }

  public func asyncAction(_ state: inout State, _ action: AsyncAction) -> ComposableArchitecture.Effect<Action> {
    return .none
  }


}
