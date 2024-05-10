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
  var defaultItems: [Item] = CreateEnvelopeAdditionalSectionSceneType.allCases.map { .init(type: $0) }

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

  mutating func startPush() {
    currentSectionIndex = 0
    currentSection = nil
  }

  mutating func sortItems() {
    selectedID.sort()
  }

  func isSelected() -> Bool {
    return !selectedID.isEmpty
  }

  mutating func pushNextSection(from type: CreateEnvelopeAdditionalSectionSceneType?) {
    let uuidByType = CreateEnvelopeAdditionalSectionSceneType.UUIDByType
    let typeByUUID = CreateEnvelopeAdditionalSectionSceneType.typeByUUID

    // MARK: - 첫 화면에서 푸쉬 할 때 selectedID 의 맨 앞의 section으로 이동합니다.

    guard let type else {
      if let firstSectionID = selectedID.first,
         let firstSection = uuidByType[firstSectionID] {
        currentSection = firstSection
      }
      return
    }
    guard
      let currentID = typeByUUID[type], // always pass
      let currentSelectedIDIndex = selectedID.firstIndex(of: currentID), // always pass
      selectedID.indices.contains(currentSelectedIDIndex + 1)
    else {
      // MARK: - 만약 현재 index + 1 보다 넘는 view 가 없을 경우 현재 선택 View 를 nil 로 돌립니다.

      currentSection = nil
      return
    }

    // MARK: - NextSection을 바꿉니다.

    let nextSection = uuidByType[selectedID[currentSelectedIDIndex + 1]]
    currentSection = nextSection
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
