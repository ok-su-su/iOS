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
import SSLayout
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

      // TODO: - Use SERVER API
      self.filterHelper.setFakeData()
    }

    var filterByTextField: [SentPerson] {
      guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
        return []
      }
      return filterHelper.sentPeople.filter { $0.name.contains(regex) }
    }
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear(Bool)
    case tappedPerson(UUID)
    case tappedSelectedPerson(UUID)
    case reset
    case tappedConfirmButton
    case header(HeaderViewFeature.Action)
    case customTextField(CustomTextField.Action)
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature(enableDismissAction: false)
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
          await dismiss()
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

      case .binding:
        return .none

      case .header:
        return .none

      case .customTextField:
        return .none

      case .tappedConfirmButton:
        return .run { _ in await dismiss() }
      }
    }
  }

  init() {}
}
