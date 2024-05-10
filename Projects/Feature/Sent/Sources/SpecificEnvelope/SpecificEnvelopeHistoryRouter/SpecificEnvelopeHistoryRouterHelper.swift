//
//  SpecificEnvelopeHistoryRouterHelper.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SpecificEnvelopeHistoryRouterHelper: Equatable {
  var specificEnvelopeHistoryListProperty: SpecificEnvelopeHistoryListProperty

  // TODO: API Logic
  init() {
    specificEnvelopeHistoryListProperty = .init(
      envelopePriceProgressProperty: .makeFakeData(),
      envelopeContents: (0 ..< 100).map { _ in return .fakeData() }
    )
  }

  init(specificEnvelopeHistoryListProperty: SpecificEnvelopeHistoryListProperty) {
    self.specificEnvelopeHistoryListProperty = specificEnvelopeHistoryListProperty
  }
}
