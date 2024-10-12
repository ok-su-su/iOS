//
//  SentPeopleFilterHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import SSFilter
import SwiftUI

// MARK: - SentPeopleFilterHelper

struct SentPeopleFilterHelper: Equatable {
  static func == (lhs: SentPeopleFilterHelper, rhs: SentPeopleFilterHelper) -> Bool {
    lhs.sentPeople == rhs.sentPeople
  }

  var sentPeople: [SentPerson]
  var selectedPerson: [SentPerson] = []

  var lowestAmount: Int64? = nil
  var highestAmount: Int64? = nil

  var isFilteredAmount: Bool {
    return lowestAmount != nil && highestAmount != nil
  }

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
  }

  mutating func updateSentPeople(_ people: [SentPerson]) {
    sentPeople = (people + sentPeople).uniqued()
  }

  mutating func select(sentPerson: SentPerson) {
    if selectedPerson.contains(sentPerson) {
      selectedPerson.removeAll(where: { $0 == sentPerson })
    } else {
      selectedPerson.append(sentPerson)
    }
  }

  mutating func select(selectedId: Int64) {
    if selectedPerson.contains(where: { $0.id == selectedId }) {
      selectedPerson.removeAll(where: { $0.id == selectedId })
    } else if let person = sentPeople.first(where: { $0.id == selectedId }) {
      selectedPerson.append(person)
    }
  }

  func isSelected(id: Int64) -> Bool {
    return selectedPerson.first(where: { $0.id == id }) != nil
  }

  func isSelected(_ person: SentPerson) -> Bool {
    return selectedPerson.contains(person)
  }

  mutating func reset() {
    selectedPerson.removeAll()
  }
}

// MARK: - SentPerson

struct SentPerson: Identifiable, Equatable, Hashable, Sendable {
  let id: Int64
  var name: String
  init(id: Int64, name: String) {
    self.id = id
    self.name = name
  }
}

// MARK: SSFilterItemable

extension SentPerson: SSFilterItemable {
  var title: String {
    get { name }
    set { name = newValue }
  }
}
