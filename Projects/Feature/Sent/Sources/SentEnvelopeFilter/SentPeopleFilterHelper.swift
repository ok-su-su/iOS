//
//  SentPeopleFilterHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - SentPeopleFilterHelper

struct SentPeopleFilterHelper: Equatable {
  static func == (lhs: SentPeopleFilterHelper, rhs: SentPeopleFilterHelper) -> Bool {
    lhs.sentPeople == rhs.sentPeople
  }

  var sentPeople: [SentPerson]
  var selectedPerson: [SentPerson] = []
  var ssButtonProperties: [UUID: SSButtonPropertyState] = [:]

  init() { sentPeople = [] }

  init(sentPeople: [SentPerson]) {
    self.sentPeople = sentPeople
    sentPeople.forEach { sentPerson in
      ssButtonProperties[sentPerson.id] = .init(
        size: .xsh28,
        status: .inactive,
        style: .lined,
        color: .black,
        buttonText: sentPerson.name
      )
    }
  }

  mutating func updateSentPeople(_ people: [SentPerson]) {
    sentPeople = people
    ssButtonProperties.removeAll()
    sentPeople.forEach { sentPerson in
      ssButtonProperties[sentPerson.id] = .init(
        size: .xsh28,
        status: .inactive,
        style: .lined,
        color: .black,
        buttonText: sentPerson.name
      )
    }
  }

  mutating func select(selectedId: UUID) {
    if
      let ind = selectedPerson.firstIndex(where: { $0.id == selectedId }),
      let propertyIndex = sentPeople.firstIndex(where: { $0.id == selectedId }) {
      selectedPerson.remove(at: ind)
      ssButtonProperties[sentPeople[propertyIndex].id]?.toggleStatus()
    } else if let ind = sentPeople.firstIndex(where: { $0.id == selectedId }) {
      ssButtonProperties[sentPeople[ind].id]?.toggleStatus()
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
