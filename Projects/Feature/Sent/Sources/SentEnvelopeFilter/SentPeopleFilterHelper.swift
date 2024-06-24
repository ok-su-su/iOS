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
  var ssButtonProperties: [Int: SSButtonPropertyState] = [:]

  var lowestAmount: Int? = nil
  var highestAmount: Int? = nil

  var amountFilterBadgeText: String? {
    guard let highestAmount,
          let lowestAmount,
          let lowVal = CustomNumberFormatter.formattedByThreeZero(lowestAmount, subFixString: nil),
          let highVal = CustomNumberFormatter.formattedByThreeZero(highestAmount, subFixString: nil)
    else {
      return nil
    }
    return "\(lowVal)~\(highVal)"
  }

  mutating func deselectAmount() {
    lowestAmount = nil
    highestAmount = nil
  }

  init(sentPeople: [SentPerson] = []) {
    self.sentPeople = sentPeople
    setButtonProperties()
  }

  private mutating func setButtonProperties() {
    ssButtonProperties.removeAll()
    for sentPerson in sentPeople {
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
    sentPeople = (people + sentPeople).uniqued()
    setButtonProperties()
  }

  mutating func select(selectedId: Int) {
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
    for person in selectedPerson {
      select(selectedId: person.id)
    }
  }
}

// MARK: - SentPerson

struct SentPerson: Identifiable, Equatable, Hashable {
  let id: Int
  let name: String
  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}
