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

  var eventSectionButtonHelper: SingleSelectButtonHelper<EventSingeSelectButtonItem>
  var eventSectionButtonCustomItem: EventSingeSelectButtonItem = .init(title: "")

  var relationSectionButtonHelper: SingleSelectButtonHelper<RelationSelectButtonItem>
  var relationSectionButtonCustomItem: RelationSelectButtonItem = .init(title: "")

  var nameEditProperty: NameEditProperty

  var dateEditProperty: DateEditProperty

  var visitedSectionButtonHelper: SingleSelectButtonHelper<VisitedSelectButtonItem>
  var visitedEditProperty: VisitedEditProperty

  var giftEditProperty: GiftEditProperty

  var contactEditProperty: ContactEditProperty

  var memoEditProperty: MemoEditProperty

  init(envelopeDetailProperty: EnvelopeDetailProperty) {
    self.envelopeDetailProperty = envelopeDetailProperty

    eventSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.eventName,
      items: EventSingeSelectButtonItem.defaultItems(),
      isCustomItem: eventSectionButtonCustomItem,
      customTextFieldPrompt: "경조사 이름"
    )

    relationSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.relationTitle,
      items: RelationSelectButtonItem.defaultItems(),
      isCustomItem: relationSectionButtonCustomItem,
      customTextFieldPrompt: "관계 이름"
    )

    nameEditProperty = .init(textFieldText: envelopeDetailProperty.eventName)

    dateEditProperty = .init(date: envelopeDetailProperty.date)

    visitedSectionButtonHelper = .init(
      titleText: envelopeDetailProperty.visitedTitle,
      items: VisitedSelectButtonItem.defaultItems(),
      isCustomItem: nil,
      customTextFieldPrompt: nil
    )
    visitedEditProperty = .init(isVisited: envelopeDetailProperty.isVisited)

    giftEditProperty = .init(gift: envelopeDetailProperty.gift ?? "")

    contactEditProperty = .init(contact: envelopeDetailProperty.contacts ?? "")

    memoEditProperty = .init(memo: envelopeDetailProperty.memo ?? "")
  }

  mutating func changeName(_ name: String) {
    nameEditProperty.textFieldText = name
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
  var id: UUID = .init()
  var title: String = ""
  var isVisited: Bool
  init(isVisited: Bool) {
    self.isVisited = isVisited
    setTitle(by: isVisited)
  }

  mutating func setTitle(by isVisited: Bool) {
    title = isVisited ? "예" : "아니오"
  }
}

extension VisitedSelectButtonItem {
  static func defaultItems() -> [Self] {
    return [
      .init(isVisited: true),
      .init(isVisited: false),
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
  var id: UUID = .init()

  var title: String

  init(title: String) {
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
    return defaultRelationNames.map { .init(title: $0) }
  }
}

// MARK: - EventSingeSelectButtonItem

struct EventSingeSelectButtonItem: SingleSelectButtonItemable {
  var id: UUID = .init()
  var title: String
  init(title: String) {
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
    return defaultsEventNames.map { .init(title: $0) }
  }
}
