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
  var eventSectionButtonCustomItem: CreateEnvelopeEventProperty

  var relationSectionButtonHelper: SingleSelectButtonHelper<CreateEnvelopeRelationItemProperty>
  var relationSectionButtonCustomItem: CreateEnvelopeRelationItemProperty

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

    // 만약 현재 관계가 default 이벤트에 존재 하지 않는다면
    relationSectionButtonCustomItem = .init(
      id: relationItems.count,
      title: !relationItems.contains { $0.title == envelopeDetailProperty.relation } ? envelopeDetailProperty.relation : ""
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
    return CustomDateFormatter.getKoreanDateString(from: date)
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
