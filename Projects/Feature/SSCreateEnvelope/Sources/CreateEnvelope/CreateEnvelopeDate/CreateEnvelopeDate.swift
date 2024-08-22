//
//  CreateEnvelopeDate.swift
//  Sent
//
//  Created by MaraMincho on 5/6/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import FeatureAction
import Foundation
import SSBottomSelectSheet

// MARK: - CreateEnvelopeDate

@Reducer
public struct CreateEnvelopeDate {
  @ObservableState
  public struct State: Equatable {
    var isOnAppear = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    @Shared var selectedDate: Date
    @Shared var isInitialStateOfDate: Bool

    @Presents var datePicker: SSDateSelectBottomSheetReducer.State? = nil
    var envelopeTargetName: String
    var createType = CreateEnvelopeRequestShared.getCreateType()

    var yearStringText: String {
      return CustomDateFormatter.getYear(from: selectedDate)
    }

    var monthStringText: String {
      return CustomDateFormatter.getMonth(from: selectedDate)
    }

    var dayStringText: String {
      return CustomDateFormatter.getDay(from: selectedDate)
    }

    var pushable: Bool {
      !isInitialStateOfDate
    }

    public init(_ createEnvelopeProperty: Shared<CreateEnvelopeProperty>) {
      _createEnvelopeProperty = createEnvelopeProperty
      _selectedDate = .init(.now)
      _isInitialStateOfDate = .init(true)
      envelopeTargetName = CreateFriendRequestShared.getName() ?? "김수수"
    }

    func resetDatePicker() {
      isInitialStateOfDate = true
      selectedDate = .now
    }
  }

  public enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  public enum ViewAction: Equatable {
    case onAppear(Bool)
    case tappedNextButton
    case tappedDateSheet
    case tappedDatePickerNextButton
  }

  public enum InnerAction: Equatable {
    case push
  }

  public enum AsyncAction: Equatable {}

  @CasePathable
  public enum ScopeAction: Equatable {
    case datePicker(PresentationAction<SSDateSelectBottomSheetReducer.Action>)
  }

  public enum DelegateAction: Equatable {}

  @Dependency(\.dismiss) var dismiss
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        state.datePicker = .init(selectedDate: state.$selectedDate, isInitialStateOfDate: state.$isInitialStateOfDate)
        return .none

      case .view(.tappedNextButton):
        return .send(.inner(.push))

      case .view(.tappedDatePickerNextButton):
        return .concatenate(
          .send(.scope(.datePicker(.presented(.didTapConfirmButton)))),
          .send(.scope(.datePicker(.dismiss))),
          .send(.inner(.push))
        )
      case .inner(.push):
        CreateEnvelopeRequestShared.setDate(state.selectedDate)
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeAdditionalSection(.init(state.$createEnvelopeProperty)))
        return .none

      case .scope(.datePicker):
        return .none

      case .view(.tappedDateSheet):
        state.datePicker = .init(selectedDate: state.$selectedDate, isInitialStateOfDate: state.$isInitialStateOfDate)
        return .none
      }
    }
    .addFeatures()
  }
}

extension Reducer where State == CreateEnvelopeDate.State, Action == CreateEnvelopeDate.Action {
  func addFeatures() -> some ReducerOf<Self> {
    ifLet(\.$datePicker, action: \.scope.datePicker) {
      SSDateSelectBottomSheetReducer()
    }
  }
}
