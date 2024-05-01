//
//  EnvelopeProperty.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import Foundation

// MARK: - EnvelopeProperty

struct EnvelopeProperty: Equatable, Hashable, Identifiable {
  var id: UUID = .init()
  init() {}

  var envelopeContents: [EnvelopeContent] = [
    .init(),
    .init(),
    .init(),
  ]
}

// MARK: - EnvelopeContent

struct EnvelopeContent: Equatable, Hashable, Identifiable {
  let id: UUID = .init()

  var isHighlight: Bool {
    return id.hashValue % 2 == 0
  }
}
