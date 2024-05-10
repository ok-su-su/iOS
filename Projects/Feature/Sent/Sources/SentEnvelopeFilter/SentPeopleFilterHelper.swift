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
    setButtonProperties()
  }

  private mutating func setButtonProperties() {
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

  mutating func setFakeData() {
    sentPeople = [
      .init(name: "정국"),
      .init(name: "국자"),
      .init(name: "개코"),
      .init(name: "최자"),
      .init(name: "헤이즈"),
      .init(name: "이지은"),
      .init(name: "아이유"),
      .init(name: "박재범"),
      .init(name: "제이팍"),
      .init(name: "지지지지"),
      .init(name: "죽음의성물"),
      .init(name: "론리즐리"),
    ]
    setButtonProperties()
  }

  mutating func updateSentPeople(_ people: [SentPerson]) {
    sentPeople = people
    setButtonProperties()
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
