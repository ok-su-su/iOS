//
//  CreateEnvelopeAdditionalSectionProperty.swift
//  Sent
//
//  Created by MaraMincho on 5/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeAdditionalSectionHelper

struct CreateEnvelopeAdditionalSectionHelper: Equatable {
  // TODO: DTO 변경
  typealias Item = CreateEnvelopeAdditionalSectionProperty

  init() {}

  var selectedID: [UUID] = []
  var defaultItems: [CreateEnvelopeAdditionalSectionProperty] = CreateEnvelopeAdditionalSectionSceneType.allCases.map { .init(type: $0) }

  private var pushedItem: [Item] = []
  var currentSection: CreateEnvelopeAdditionalSectionSceneType? = nil
  private var currentSectionIndex = 0

  mutating func removeItem(_ id: UUID) {
    selectedID = selectedID.filter { $0 != id }
  }

  mutating func addItem(_ id: UUID) {
    if let curItem = CreateEnvelopeAdditionalSectionSceneType.allCases.first(where: { $0.id == id }) {
      selectedID.append(curItem.id)
    }
  }

  mutating func sortItems() {
    selectedID.sort()
  }

  func isSelected() -> Bool {
    return !selectedID.isEmpty
  }

  mutating func pushNextSection() {
    let uuidByType = CreateEnvelopeAdditionalSectionSceneType.UUIDByType
    if currentSection == nil {
      currentSectionIndex = 0
      currentSection = uuidByType[selectedID[currentSectionIndex]]
    } else if selectedID.indices.contains(currentSectionIndex + 1) {
      currentSectionIndex += 1
      currentSection = uuidByType[selectedID[currentSectionIndex]]
    } else {
      currentSection = nil
    }
  }
}

// MARK: - CreateEnvelopeAdditionalSectionProperty

struct CreateEnvelopeAdditionalSectionProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  var id: UUID {
    return type.id
  }

  var title: String {
    return type.rawValue
  }

  var type: CreateEnvelopeAdditionalSectionSceneType

  init(type: CreateEnvelopeAdditionalSectionSceneType) {
    self.type = type
  }

  mutating func setTitle(_: String) {}
}

// MARK: - CreateEnvelopeAdditionalSectionSceneType

enum CreateEnvelopeAdditionalSectionSceneType: String, Equatable, CaseIterable, Identifiable {
  var id: UUID {
    return UUID(Self.allCases.firstIndex(of: self)!)
  }

  static let typeByUUID: [CreateEnvelopeAdditionalSectionSceneType: UUID] = {
    var dict: [Self: UUID] = [:]
    Self.allCases.enumerated().forEach { dict[$0.element] = UUID($0.offset) }
    return dict
  }()

  static let UUIDByType: [UUID: CreateEnvelopeAdditionalSectionSceneType] = {
    var dict: [UUID: Self] = [:]
    Self.allCases.enumerated().forEach { dict[UUID($0.offset)] = $0.element }
    return dict
  }()

  case isVisited = "방문 여부"
  case gift = "선물"
  case memo = "메모"
  case contacts = "받은 이의 연락처"

  var title: String { return rawValue }
}
