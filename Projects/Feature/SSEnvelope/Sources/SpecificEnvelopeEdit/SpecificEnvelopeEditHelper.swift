//
//  SpecificEnvelopeEditHelper.swift
//  SSEnvelope
//
//  Created by MaraMincho on 7/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSRegexManager

// MARK: - SpecificEnvelopeEditHelper

public struct SpecificEnvelopeEditHelper: Equatable {
  var envelopeDetailProperty: EnvelopeDetailProperty

  var priceProperty: PriceEditProperty

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

  public init(
    envelopeDetailProperty: EnvelopeDetailProperty,
    eventItems: [CreateEnvelopeEventProperty],
    relationItems: [CreateEnvelopeRelationItemProperty]
  ) {
    self.envelopeDetailProperty = envelopeDetailProperty

    priceProperty = .init(price: envelopeDetailProperty.price)

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
      customTextFieldPrompt: nil,
      isEssentialProperty: false
    )

    visitedEditProperty = .init(isVisited: envelopeDetailProperty.isVisited ?? true)

    giftEditProperty = .init(gift: envelopeDetailProperty.gift ?? "")

    contactEditProperty = .init(contact: envelopeDetailProperty.contacts ?? "")

    memoEditProperty = .init(memo: envelopeDetailProperty.memo ?? "")
  }

  mutating func changeName(_ name: String) {
    nameEditProperty.textFieldText = name
  }

  func isValidName() -> Bool {
    nameEditProperty.isValid
  }

  mutating func changeGift(_ name: String) {
    giftEditProperty.gift = name
  }

  func isValidGift() -> Bool {
    giftEditProperty.isValid
  }

  mutating func changeContact(_ name: String) {
    contactEditProperty.contact = name
  }

  func isValidContact() -> Bool {
    contactEditProperty.isValid
  }

  mutating func changeMemo(_ name: String) {
    memoEditProperty.memo = name
  }

  func isValidMemo() -> Bool {
    memoEditProperty.isValid
  }

  mutating func changePrice(_ value: String) {
    priceProperty.setPriceTextFieldText(value)
  }

  func isValidPrice() -> Bool {
    priceProperty.isValid
  }

  func isValidToSave() -> Bool {
    (priceProperty.isValid) &&
      (eventSectionButtonHelper.isValid()) &&
      (nameEditProperty.isValid) &&
      (relationSectionButtonHelper.isValid())
    // 데이트는 항상 참이니까 제외
  }
}

// MARK: - PriceEditProperty

struct PriceEditProperty: Equatable {
  var price: Int64
  var priceTextFieldText: String
  var priceText: String

  init(price: Int64) {
    self.price = price
    priceTextFieldText = price.description
    priceText = CustomNumberFormatter.formattedByThreeZero(price, subFixString: "원") ?? ""
  }

  mutating func setPriceTextFieldText(_ text: String) {
    priceTextFieldText = text.isEmpty ? "0" : text
    guard let currentValue = Int64(priceTextFieldText) else {
      return
    }
    price = currentValue
    priceText = CustomNumberFormatter.formattedByThreeZero(currentValue, subFixString: "원") ?? ""
  }

  var isValid: Bool {
    RegexManager.isValidPrice(priceTextFieldText)
  }
}

// MARK: - GiftEditProperty

struct GiftEditProperty: Equatable {
  var gift: String

  init(gift: String) {
    self.gift = gift
  }

  var isValid: Bool {
    RegexManager.isValidGift(gift)
  }
}

// MARK: - ContactEditProperty

struct ContactEditProperty: Equatable {
  var contact: String

  init(contact: String) {
    self.contact = contact
  }

  var isValid: Bool {
    RegexManager.isValidContacts(contact)
  }
}

// MARK: - MemoEditProperty

struct MemoEditProperty: Equatable {
  var memo: String
  init(memo: String) {
    self.memo = memo
  }

  var isValid: Bool {
    RegexManager.isValidMemo(memo)
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

public struct VisitedSelectButtonItem: SingleSelectButtonItemable {
  public var id: Int
  public var title: String = ""
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

  var isValid: Bool {
    RegexManager.isValidName(textFieldText)
  }
}

// MARK: - CreateEnvelopeEventProperty

public struct CreateEnvelopeEventProperty: Equatable, Identifiable, SingleSelectButtonItemable {
  public var id: Int
  public var title: String

  mutating func setTitle(_ val: String) {
    title = val
  }

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

// MARK: - CreateEnvelopeRelationItemProperty

public struct CreateEnvelopeRelationItemProperty: Equatable, Identifiable, SingleSelectButtonItemable {
  public var id: Int
  public var title: String

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }

  mutating func setTitle(_ val: String) {
    title = val
  }
}
