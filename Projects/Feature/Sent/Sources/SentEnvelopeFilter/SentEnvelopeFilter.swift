//
//  SentEnvelopeFilter.swift
//  Sent
//
//  Created by MaraMincho on 4/29/24.
//  Copyright © 2024 com.susu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation
import OSLog
import SwiftUI

// MARK: - SentEnvelopeFilter

@Reducer
struct SentEnvelopeFilter {
  @ObservableState
  struct State {
    var isOnAppear = false
    var textFieldText: String = ""
    var isHighlight: Bool = true
    var sentPeopleAdaptor: SentPeopleAdaptor
    var header: HeaderViewFeature.State = .init(.init(title: "필터", type: .depth2Default))
    var sliderProperty: CustomSlider = .init(start: 0, end: 100_000, width: UIScreen.main.bounds.size.width - 42)
    init(sentPeople: [SentPerson]) {
      sentPeopleAdaptor = .init(sentPeople: sentPeople)
    }

    var filterByTextField: [SentPerson] {
      guard let regex: Regex = try? .init("[\\w\\p{L}]*\(textFieldText)[\\w\\p{L}]*") else {
        return []
      }
      return sentPeopleAdaptor.sentPeople.filter { $0.name.contains(regex) }
    }
  }

  enum Action: BindableAction, Equatable {
    case onAppear(Bool)
    case binding(BindingAction<State>)
    case header(HeaderViewFeature.Action)
    case tappedPerson(UUID)
    case tappedSelectedPerson(UUID)
    case reset
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .tappedPerson(ind):
        state.sentPeopleAdaptor.select(selectedId: ind)
        return .none
      case let .tappedSelectedPerson(ind):
        state.sentPeopleAdaptor.select(selectedId: ind)
        return .none
      case .reset:
        state.sentPeopleAdaptor.reset()
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

// MARK: - SentPeopleAdaptor

struct SentPeopleAdaptor {
  var sentPeople: [SentPerson]

  var selectedPerson: [SentPerson] = []
  var ssButtonProperties: [SSButtonPropertyState] = []

  init(sentPeople: [SentPerson]) {
    self.sentPeople = sentPeople
    sentPeople.forEach { sentPerson in
      ssButtonProperties.append(
        .init(
          size: .xsh28,
          status: .inactive,
          style: .lined,
          color: .black,
          buttonText: sentPerson.name
        )
      )
    }
  }

  mutating func select(selectedId: UUID) {
    if
      let ind = selectedPerson.firstIndex(where: { $0.id == selectedId }),
      let propertyIndex = sentPeople.firstIndex(where: { $0.id == selectedId }) {
      selectedPerson.remove(at: ind)
      ssButtonProperties[propertyIndex].toggleStatus()
    } else if let ind = sentPeople.firstIndex(where: { $0.id == selectedId }) {
      ssButtonProperties[ind].toggleStatus()
      selectedPerson.append(sentPeople[ind])
    }
  }

  mutating func reset() {
    selectedPerson.forEach { person in
      select(selectedId: person.id)
    }
  }
}

// MARK: - SentPerson

struct SentPerson: Identifiable, Equatable {
  let id = UUID()
  let name: String
  init(name: String) {
    self.name = name
  }
}
