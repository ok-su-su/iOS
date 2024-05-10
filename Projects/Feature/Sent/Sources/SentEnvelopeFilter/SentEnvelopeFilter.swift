//
//  SentEnvelopeFilter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import OSLog
import SwiftUI

// MARK: - SentEnvelopeFilter

@Reducer
struct SentEnvelopeFilter {
  @ObservableState
  struct State {
    var isOnAppear = false
    @Shared var textFieldText: String
    @Shared var filterHelper: SentPeopleFilterHelper

    // MARK: - Scope

    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var sliderProperty: CustomSlider = .init(start: 0, end: 100_000, width: UIScreen.main.bounds.size.width - 42)
    var customTextField: CustomTextField.State
    init(filterHelper: Shared<SentPeopleFilterHelper>) {
      _filterHelper = filterHelper
      _textFieldText = .init("")
      customTextField = .init(text: _textFieldText)
    }

    var filterByTextField: [SentPerson] {
      guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
        return []
      }
      return filterHelper.sentPeople.filter { $0.name.contains(regex) }
    }
  }

  enum Action: BindableAction, Equatable {
    case onAppear(Bool)
    case binding(BindingAction<State>)
    case header(HeaderViewFeature.Action)
    case tappedPerson(UUID)
    case tappedSelectedPerson(UUID)
    case reset
    case delegate(Delegate)
    case customTextField(CustomTextField.Action)
    enum Delegate: Equatable {
      case tappedApplyButton(SentPeopleFilterHelper)
    }
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }

    Scope(state: \.customTextField, action: \.customTextField) {
      CustomTextField()
    }

    BindingReducer()

    Reduce { state, action in
      switch action {
      case .header(.tappedDismissButton):
        return .run { send in
          await send(.reset)
        }
      case let .tappedPerson(ind):
        state.filterHelper.select(selectedId: ind)
        return .none
      case let .tappedSelectedPerson(ind):
        state.filterHelper.select(selectedId: ind)
        return .none
      case .reset:
        state.filterHelper.reset()
        return .none
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }

  init() {}
}
