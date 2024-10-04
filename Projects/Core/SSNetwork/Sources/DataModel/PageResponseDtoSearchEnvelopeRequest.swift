//
//  PageResponseDtoSearchEnvelopeRequest.swift
//  SSNetwork
//
//  Created by MaraMincho on 9/5/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - PageResponseDtoSearchEnvelopeRequest

public struct PageResponseDtoSearchEnvelopeRequest: Sendable {
  public var friendIds: [Int64] = []
  public var friendName: String?
  public var ledgerId: Int64?
  public var types: CurrentTypes?
  public var include: [IncludeType] = []
  public var fromAmount: Int64?
  public var toAmount: Int64?
  public var page = 0
  public var size = PageResponseDtoSearchEnvelopeRequest.defaultSize
  public var sort: String?

  public init(
    friendIds: [Int64] = [],
    friendName: String? = nil,
    ledgerId: Int64? = nil,
    types: CurrentTypes? = nil,
    include: [IncludeType] = [],
    fromAmount: Int64? = nil,
    toAmount: Int64? = nil,
    page: Int = 0,
    size: Int = PageResponseDtoSearchEnvelopeRequest.defaultSize,
    sort: String? = nil
  ) {
    self.friendIds = friendIds
    self.ledgerId = ledgerId
    self.friendName = friendName
    self.types = types
    self.include = include
    self.fromAmount = fromAmount
    self.toAmount = toAmount
    self.page = page
    self.size = size
    self.sort = sort
  }

  public enum CurrentTypes: String, CustomStringConvertible, Sendable {
    case received
    case sent
    public var description: String { rawValue.uppercased() }
  }

  public enum IncludeType: String, CustomStringConvertible, CaseIterable, Sendable {
    case category = "CATEGORY"
    case friend = "FRIEND"
    case relationship = "RELATIONSHIP"
    case friendRelationship = "FRIEND_RELATIONSHIP"

    public var description: String { rawValue }
  }
}

public extension PageResponseDtoSearchEnvelopeRequest {
  static let defaultSize = 10

  func getParameter() -> [String: Any] {
    var res: [String: Any] = [:]
    res["friendIds"] = friendIds
    res["friendName"] = friendName
    res["ledgerId"] = ledgerId
    res["types"] = types?.description
    res["include"] = include.isEmpty ? IncludeType.allCases.map(\.description) : include.map(\.description)
    if let fromAmount {
      res["fromAmount"] = fromAmount
    }
    if let toAmount {
      res["toAmount"] = toAmount
    }
    res["size"] = size
    res["page"] = page
    res["sort"] = sort

    return res
  }
}
