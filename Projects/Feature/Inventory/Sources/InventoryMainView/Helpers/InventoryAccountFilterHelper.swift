//
//  InventoryAccountFilterHelper.swift
//  Inventory
//
//  Created by Kim dohyun on 6/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Designsystem

// MARK: - InventoryAccountItems

struct InventoryAccountItems: Identifiable, Equatable {
  let id = UUID()
  let name: String

  init(name: String) {
    self.name = name
  }
}

// MARK: - InventoryAccountFilterHelper

struct InventoryAccountFilterHelper: Equatable {
  var remitPerson: [InventoryAccountItems]
  var selectedPerson: [InventoryAccountItems] = []
  var ssButtonProperties: [UUID: SSButtonPropertyState] = [:]

  init(remittPerson: [InventoryAccountItems]) {
    remitPerson = remittPerson
  }

  mutating func fakeEntity() {
    remitPerson = [
      .init(name: "김철수"),
      .init(name: "최지환"),
      .init(name: "이민지"),
      .init(name: "박예은"),
      .init(name: "박미영"),
      .init(name: "서한누리"),
      .init(name: "박솔미"),
    ]
    setButtonPorperties()
  }

  private mutating func setButtonPorperties() {
    ssButtonProperties.removeAll()
    for person in remitPerson {
      ssButtonProperties[person.id] = .init(
        size: .xsh28,
        status: .inactive,
        style: .lined,
        color: .black,
        buttonText: person.name
      )
    }
  }

  mutating func select(selectedId: UUID) {
    if let index = selectedPerson.firstIndex(where: { $0.id == selectedId }),
       let propertyIndex = remitPerson.firstIndex(where: { $0.id == selectedId }) {
      selectedPerson.remove(at: index)
      ssButtonProperties[remitPerson[propertyIndex].id]?.toggleStatus()
    } else if let index = remitPerson.firstIndex(where: { $0.id == selectedId }) {
      ssButtonProperties[remitPerson[index].id]?.toggleStatus()
      selectedPerson.append(remitPerson[index])
    }
  }

  mutating func reset() {
    for remitPerson in selectedPerson {
      select(selectedId: remitPerson.id)
    }
  }

  static func == (lhs: InventoryAccountFilterHelper, rhs: InventoryAccountFilterHelper) -> Bool {
    lhs.remitPerson == rhs.remitPerson
  }
}
