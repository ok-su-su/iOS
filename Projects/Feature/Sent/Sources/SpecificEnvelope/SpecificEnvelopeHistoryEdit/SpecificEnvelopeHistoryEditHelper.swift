//
//  SpecificEnvelopeHistoryEditHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - SpecificEnvelopeHistoryEditHelper

struct SpecificEnvelopeHistoryEditHelper: Equatable {
  var envelopeDetailProperty: EnvelopeDetailProperty

  var eventSectionButtonHelper: SingleSelectButtonHelper<CreateEnvelopeEventProperty>
  var eventSectionButtonCustomItem: CreateEnvelopeEventProperty = .init(id: -1, title: "")

  var relationSectionButtonHelper: SingleSelectButtonHelper<CreateEnvelopeRelationItemProperty>
  var relationSectionButtonCustomItem: CreateEnvelopeRelationItemProperty = .init(id: -1, title: "")

  var nameEditProperty: NameEditProperty

  var dateEditProperty: DateEditProperty

  var visitedSectionButtonHelper: SingleSelectButtonHelper<VisitedSelectButtonItem>
  var visitedEditProperty: VisitedEditProperty

  var giftEditProperty: GiftEditProperty

  var contactEditProperty: ContactEditProperty

  var memoEditProperty: MemoEditProperty

  init(
    envelopeDetailProperty: EnvelopeDetailProperty,
    eventItems: [CreateEnvelopeEventProperty],
    relationItems: [CreateEnvelopeRelationItemProperty]
  ) {
    self.envelopeDetailProperty = envelopeDetailProperty

    // 만약 현재 이벤트가 default 이벤트에 존재 하지 않는다면
    eventSectionButtonCustomItem = .init(
      id: eventItems.count,
      title: !eventItems.contains { $0.title == envelopeDetailProperty.eventName } ? envelopeDetailProperty.eventName : ""
    )

    eventSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.eventNameTitle,
      items: eventItems,
      isCustomItem: eventSectionButtonCustomItem,
      customTextFieldPrompt: "경조사 이름"
    )

    relationSectionButtonCustomItem = .init(
      id: eventItems.count,
      title: !eventItems.contains { $0.title == envelopeDetailProperty.relation } ? envelopeDetailProperty.relation : ""
    )

    relationSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.relationTitle,
      items: relationItems,
      isCustomItem: relationSectionButtonCustomItem,
      customTextFieldPrompt: "관계 이름"
    )

    nameEditProperty = .init(textFieldText: envelopeDetailProperty.name)

    dateEditProperty = .init(date: envelopeDetailProperty.date)

    visitedSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.visitedTitle,
      items: VisitedSelectButtonItem.defaultItems(),
      isCustomItem: nil,
      customTextFieldPrompt: nil
    )

    visitedEditProperty = .init(isVisited: envelopeDetailProperty.isVisited ?? true)

    giftEditProperty = .init(gift: envelopeDetailProperty.gift ?? "")

    contactEditProperty = .init(contact: envelopeDetailProperty.contacts ?? "")

    memoEditProperty = .init(memo: envelopeDetailProperty.memo ?? "")
  }

  mutating func changeName(_ name: String) {
    nameEditProperty.textFieldText = name
  }

  mutating func changeGift(_ name: String) {
    giftEditProperty.gift = name
  }

  mutating func changeContact(_ name: String) {
    contactEditProperty.contact = name
  }

  mutating func changeMemo(_ name: String) {
    memoEditProperty.memo = name
  }
}

// MARK: - GiftEditProperty

struct GiftEditProperty: Equatable {
  var gift: String

  init(gift: String) {
    self.gift = gift
  }
}

// MARK: - ContactEditProperty

struct ContactEditProperty: Equatable {
  var contact: String

  init(contact: String) {
    self.contact = contact
  }
}

// MARK: - MemoEditProperty

struct MemoEditProperty: Equatable {
  var memo: String
  init(memo: String) {
    self.memo = memo
  }
}

// MARK: - VisitedEditProperty

struct VisitedEditProperty: Equatable {
  var isVisited: Bool

  init(isVisited: Bool) {
    self.isVisited = isVisited
  }
}

// MARK: - VisitedSelectButtonItem

struct VisitedSelectButtonItem: SingleSelectButtonItemable {
  var id: Int
  var title: String = ""
  var isVisited: Bool
  init(id: Int, title: String = "", isVisited: Bool) {
    self.id = id
    self.title = title
    self.isVisited = isVisited
  }

  mutating func setTitle(by isVisited: Bool) {
    title = isVisited ? "예" : "아니오"
  }
}

extension VisitedSelectButtonItem {
  static func defaultItems() -> [Self] {
    return [
      .init(id: 0, title: "예", isVisited: true),
      .init(id: 1, title: "아니오", isVisited: false),
    ]
  }
}

// MARK: - DateEditProperty

struct DateEditProperty: Equatable {
  var date: Date

  var dateText: String {
    return "2023년 11월 25일"
  }

  init(date: Date) {
    self.date = date
  }
}

// MARK: - NameEditProperty

/// EditName을 하기 위해 사용됩니다.
struct NameEditProperty: Equatable {
  var textFieldText: String
}

// MARK: - RelationSelectButtonItem

struct RelationSelectButtonItem: SingleSelectButtonItemable {
  var id: Int

  var title: String

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

extension RelationSelectButtonItem {
  static func defaultItems() -> [Self] {
    let defaultRelationNames: [String] = [
      "친구",
      "가족",
      "친척",
      "동료",
    ]
    return defaultRelationNames.enumerated().map { .init(id: $0.offset, title: $0.element) }
  }
}

// MARK: - EventSingeSelectButtonItem

struct EventSingeSelectButtonItem: SingleSelectButtonItemable {
  var id: Int
  var title: String
  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

extension EventSingeSelectButtonItem {
  static func defaultItems() -> [Self] {
    let defaultsEventNames: [String] = [
      "결혼식",
      "돌잔치",
      "장례식",
      "생일기념일",
    ]
    return defaultsEventNames.enumerated().map { .init(id: $0.offset, title: $0.element) }
  }
}
