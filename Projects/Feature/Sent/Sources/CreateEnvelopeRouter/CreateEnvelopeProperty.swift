//
//  CreateEnvelopeProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeProperty

struct CreateEnvelopeProperty: Equatable {
  var viewDepth = 1
  var createEnvelopeAdditionalSectionManager: CreateEnvelopeAdditionalSectionManager = .init()
  var relationAdaptor: CreateEnvelopeRelationItemPropertyAdapter = .init()
  init() {}

  var prevNames: [PrevEnvelope] = [
    .init(name: "김철수", relationShip: "친구", eventName: "결혼식", eventDate: .now),
    .init(name: "김철수", relationShip: "친구", eventName: "결혼식", eventDate: .now),
    .init(name: "김채원", relationShip: "동료", eventName: "결혼식", eventDate: .now),
    .init(name: "김채소", relationShip: "동창", eventName: "결혼식", eventDate: .now),
  ]

  var customRelation: [String] = [
    "동창",
  ]

  // TODO: - change Names
  func filteredName(_ value: String) -> [PrevEnvelope] {
    guard let regex: Regex = try? .init("[\\w\\p{L}]*\(value)[\\w\\p{L}]*") else {
      return []
    }
    return prevNames.filter { $0.name.contains(regex) }
  }
}

// MARK: - PrevEnvelope

// TODO: - change DTO
struct PrevEnvelope: Equatable {
  let name: String
  let relationShip: String
  let eventName: String
  let eventDate: Date
}

// MARK: - CreateEnvelopeAdditionalSectionManager

struct CreateEnvelopeAdditionalSectionManager: Equatable {
  // TODO: DTO 변경
  typealias Item = CreateEnvelopeAdditionalSectionProperty

  init() {
    defaultItems = Item.allCases
  }

  var defaultItemTitles: [String] { Item.allCases.map(\.title) }
  var selectedItemTitles: [String] { selectedItem.map(\.title) }

  private var defaultItems: [CreateEnvelopeAdditionalSectionProperty]
  private var selectedItem: [Item] = []
  private var pushedItem: [Item] = []
  var currentSection: CreateEnvelopeAdditionalSectionProperty? = nil
  private var currentSectionIndex = 0

  mutating func removeItem(_ item: String) {
    selectedItem = selectedItem.filter { $0.title != item }
  }

  mutating func addItem(_ value: String) {
    if let curItem = CreateEnvelopeAdditionalSectionProperty(rawValue: value) {
      selectedItem.append(curItem)
    }
  }

  mutating func sortItems() {
    selectedItem = CreateEnvelopeAdditionalSectionProperty.allCases.filter { selectedItem.contains($0) }
  }

  func isSelected() -> Bool {
    return !selectedItem.isEmpty
  }

  mutating func pushNextSection() {
    if currentSection == nil {
      currentSectionIndex = 0
      currentSection = selectedItem[currentSectionIndex]
    } else if selectedItem.indices.contains(currentSectionIndex + 1) {
      currentSectionIndex += 1
      currentSection = selectedItem[currentSectionIndex]
    } else {
      currentSection = nil
    }
  }
}

// MARK: - CreateEnvelopeAdditionalSectionProperty

enum CreateEnvelopeAdditionalSectionProperty: String, Equatable, CaseIterable {
  case isVisited = "방문 여부"
  case gift = "선물"
  case memo = "메모"
  case contacts = "받은 이의 연락처"

  var title: String { return rawValue }
}
