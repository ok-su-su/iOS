//
//  EnvelopeProperty.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Foundation

// MARK: - EnvelopeProperty

public struct EnvelopeProperty: Equatable, Hashable, Identifiable {
  public var id: UUID = .init()
  public init() {}

  public var envelopeContents: [EnvelopeContent] = [
    .init(),
    .init(),
    .init(),
  ]
}

// MARK: - EnvelopeContent

public struct EnvelopeContent: Equatable, Hashable, Identifiable {
  public let id: UUID = .init()

  var isHighlight: Bool {
    return id.hashValue % 2 == 0
  }
}
